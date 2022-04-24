//
//  Podcast.h
//  Podcast
//
//  Created by 林宜萱 on 2022/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Podcast : NSObject

@property (nonatomic, strong) NSString* podcastTitle;
@property (nonatomic, strong) NSString* podcastImgString;

- (instancetype)initWithPodcastTitle:(NSString*)podcastTitle initWithPodcastImgString:(NSString*)podcastImgString;

@end

NS_ASSUME_NONNULL_END
