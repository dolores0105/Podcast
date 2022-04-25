//
//  RssParser.h
//  Podcast
//
//  Created by 林宜萱 on 2022/4/23.
//

#import <Foundation/Foundation.h>
#import "Podcast.h"
#import "Episode.h"

NS_ASSUME_NONNULL_BEGIN
@class Podcast;
@class Episode;

#pragma mark - RssParserDelegate
@protocol RssParserDelegate <NSObject>
@required
- (void) successParsedResult:(Podcast*) podcast episodeItems:(NSArray<Episode *>*)episodeItems;
- (void) failedParsed:(NSError*)error;

@end

#pragma mark - RssParser
@interface RssParser : NSObject <NSXMLParserDelegate> {
    NSXMLParser *xmlParser;
}

@property (nonatomic, strong) Podcast *podcast;
@property (nonatomic, strong) NSMutableArray<Episode *> *episodeItems;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic) bool isPodcastTitleFound;
@property (nonatomic) bool isPodcastImgFound;
@property (nonatomic, strong) NSString *podcastTitle;
@property (nonatomic, strong) NSString *podcastImageString;
@property (nonatomic, strong) NSMutableString *currentEpTitle;
@property (nonatomic, strong) NSMutableString *currentEpPubDate;
@property (nonatomic, strong) NSMutableString *currentEpDescription;
@property (nonatomic, strong) NSMutableString *currentEpAudioUrl;
@property (nonatomic, strong) NSMutableString *currentEpImage;

@property (nonatomic, weak) id<RssParserDelegate> delegate;

- (instancetype)init;

- (void) parseFeed:(NSString*)feedUrlString;

@end

NS_ASSUME_NONNULL_END
