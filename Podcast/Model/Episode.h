//
//  Episode.h
//  Podcast
//
//  Created by 林宜萱 on 2022/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Episode : NSObject
@property (nonatomic, strong) NSString* epTitle;
@property (nonatomic, strong) NSString* epImgString;
@property (nonatomic, strong) NSString* pubDate;
@property (nonatomic, strong) NSString* epDescription;
@property (nonatomic, strong) NSString* audioUrl;

- (instancetype)initWithEpTitle:(NSString*) epTitle initWithEpImgString:(NSString*) epImgString initWithPubDate:(NSString*) pubDate initWithEpDescription:(NSString*) epDescription initWithAudioUrl:(NSString*) audioUrl;

@end

NS_ASSUME_NONNULL_END
