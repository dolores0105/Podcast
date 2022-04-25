//
//  PodcastTests.swift
//  PodcastTests
//
//  Created by 林宜萱 on 2022/4/24.
//

import XCTest
@testable import Podcast
var sut: HomeViewModel!

class PodcastTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = HomeViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCatchParsedResult() throws {
        // given
        let fakePodcast = Podcast(podcastTitle: "Fake podcast", initWithPodcastImgString: "https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg")
        let fakeEpisodeItems: [Episode] = [.init(epTitle: "fake episode title",
                                                 initWithEpImgString: "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
                                                 initWithPubDate: "Sat, 14 Aug 2021 14:39:55 +0000",
                                                 initWithEpDescription: "fake description",
                                                 initWithAudioUrl: "https://feeds.soundcloud.com/stream/1062984568-daodutech-podcast-please-answer-daodu-tech.mp3")]
        
        // when
        sut.successParsedResult(fakePodcast, episodeItems: fakeEpisodeItems)
        
        // then
        XCTAssertEqual(sut.podcast, fakePodcast, "podcast is not equal")
        XCTAssertEqual(sut.episodeItems, fakeEpisodeItems, "episodeItems are not equal")
    }
}
