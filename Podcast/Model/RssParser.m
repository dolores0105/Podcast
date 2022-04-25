//
//  RssParser.m
//  Podcast
//
//  Created by 林宜萱 on 2022/4/23.
//

#import "RssParser.h"
#import "Podcast.h"
#import "Episode.h"

@implementation RssParser

#pragma mark - Initailizer
- (instancetype)init {
    if (self = [super init]) {
        _podcast = [[Podcast alloc] initWithPodcastTitle:@"" initWithPodcastImgString:@""];
        _episodeItems = [[NSMutableArray<Episode *> alloc] init];
        _currentElement = [[NSMutableString alloc] init];
        _isPodcastTitleFound = false;
        _isPodcastImgFound = false;
        _podcastTitle = [[NSMutableString alloc] init];
        _podcastImageString = [[NSMutableString alloc] init];
        _currentEpTitle = [[NSMutableString alloc] init];
        _currentEpPubDate = [[NSMutableString alloc] init];
        _currentEpDescription = [[NSMutableString alloc] init];
        _currentEpAudioUrl = [[NSMutableString alloc] init];
        _currentEpImage = [[NSMutableString alloc] init];
    }
    return self;
}

#pragma mark - Function
- (void) parseFeed:(NSString*)feedUrlString {
    NSURL *feedURL = [NSURL URLWithString:feedUrlString];
    xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:feedURL];
    xmlParser.delegate = self;
    [xmlParser parse];
};

#pragma mark - XMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _episodeItems = [NSMutableArray new];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    _currentElement = elementName;
    if ([_currentElement isEqualToString: @"item"]) {
        [_currentEpTitle setString:@""];
        [_currentEpPubDate setString:@""];
        [_currentEpDescription setString:@""];
        [_currentEpAudioUrl setString:@""];
        [_currentEpImage setString:@""];
    }

    if ([_currentElement isEqualToString: @"enclosure"]) {
        if (attributeDict[@"url"] != nil) {
            [_currentEpAudioUrl setString:attributeDict[@"url"]];
        } else {
            NSLog(@"Couldn't find url in enclosure");
        };
    }
    
    if ([_currentElement isEqualToString: @"itunes:image"] && _isPodcastImgFound) {
        if (attributeDict[@"href"] != nil) {
            [_currentEpImage setString:attributeDict[@"href"]];
        } else {
            NSLog(@"Couldn't find href in itunes:image");
        };
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElement isEqualToString: @"title"]) {
        if (_isPodcastTitleFound) {
            [_currentEpTitle appendString:string];
        } else {
            _podcastTitle = string;
        }
    }
    
    if ([_currentElement isEqualToString: @"url"]) {
        if (!_isPodcastImgFound) {
            _podcastImageString = string;
        }
    }
    
    if ([_currentElement isEqualToString: @"pubDate"]) {
        if (_isPodcastTitleFound && _isPodcastImgFound) {
            [_currentEpPubDate appendString:string];
        }
    }
    
    if ([_currentElement isEqualToString: @"description"]) {
        if (_isPodcastTitleFound && _isPodcastImgFound) {
            [_currentEpDescription appendString:string];
        }
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElement = elementName;
    
    if ([_currentElement isEqualToString:@"title"]) {
        if (!_isPodcastTitleFound) {
            _isPodcastTitleFound = true;
        }
    }

    if ([_currentElement isEqualToString:@"url"]) {
        if (!_isPodcastImgFound) {
            _isPodcastImgFound = true;
        }
    }
    
    if ([_currentElement isEqualToString: @"item"]) {
        NSString *separatorString = @"\n";
        NSString *pureEpTitle = [[_currentEpTitle componentsSeparatedByString:separatorString] objectAtIndex:0];
        NSString *pureEpPubDate = [[_currentEpPubDate componentsSeparatedByString:separatorString] objectAtIndex:0];
        _podcast = [[Podcast alloc]initWithPodcastTitle:_podcastTitle initWithPodcastImgString:_podcastImageString];
        Episode *episodeItem = [[Episode alloc]initWithEpTitle:pureEpTitle initWithEpImgString:_currentEpImage initWithPubDate:pureEpPubDate initWithEpDescription:_currentEpDescription initWithAudioUrl:_currentEpAudioUrl];
        if (episodeItem) [_episodeItems addObject:episodeItem];
    }
}

- (void) parserDidEndDocument:(NSXMLParser *)parser{
    [_delegate successParsedResult:_podcast episodeItems:_episodeItems];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [_delegate failedParsed:parseError];
}

@end
