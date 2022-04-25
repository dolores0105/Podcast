//
//  PodcastOCTests.m
//  PodcastOCTests
//
//  Created by 林宜萱 on 2022/4/24.
//

#import <XCTest/XCTest.h>
#import "RssParser.h"

@interface PodcastOCTests : XCTestCase
@property RssParser *sut;

@end

@implementation PodcastOCTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    _sut = [[RssParser alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _sut = nil;
    [super tearDown];
}

- (void)testParseFeed {
    // given
    NSString *urlString = @"https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss";
    
    // when
    NSURL *feedURL = [NSURL URLWithString:urlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:feedURL];
    
    // then
    XCTAssertTrue([xmlParser parse], @"parse failed");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
