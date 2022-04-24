//
//  Episode.m
//  Podcast
//
//  Created by 林宜萱 on 2022/4/23.
//

#import "Episode.h"

@implementation Episode

- (instancetype)initWithEpTitle:(NSString*) epTitle initWithEpImgString:(NSString*) epImgString initWithPubDate:(NSString*) pubDate initWithEpDescription:(NSString*) epDescription initWithAudioUrl:(NSString*) audioUrl{
    self = [super init];
    if (self != nil) {
        self.epTitle = epTitle;
        self.epImgString = epImgString;
        self.pubDate = pubDate;
        self.epDescription = epDescription;
        self.audioUrl = audioUrl;
    }
    return self;
}

@end
