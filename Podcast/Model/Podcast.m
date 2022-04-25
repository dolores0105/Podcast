//
//  Podcast.m
//  Podcast
//
//  Created by 林宜萱 on 2022/4/23.
//

#import "Podcast.h"

@implementation Podcast

- (instancetype)initWithPodcastTitle:(NSString*)podcastTitle initWithPodcastImgString:(NSString*)podcastImgString{
    self = [super init];
    if (self != nil) {
        self.podcastTitle = podcastTitle;
        self.podcastImgString = podcastImgString;
    }
    return self;
}

@end
