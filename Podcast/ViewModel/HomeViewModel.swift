//
//  HomeViewModel.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/19.
//

import Foundation
import UIKit

protocol UpdateParserDataDelegate: AnyObject {
    func updateFeedData()
}

class HomeViewModel {
    // MARK: - Properties
    var podcast: Podcast?
    var episodeItems: [Episode]?
    private var feedParser: FeedParser?
    
    weak var delegate: UpdateParserDataDelegate?
    
    // MARK: - Initializer
    init(feedParser: FeedParser = FeedParser()) {
        self.feedParser = feedParser
        feedParser.delegate = self
    }
    
    // MARK: - Function
    func parseFeed() {
        feedParser?.parseFeed(feedUrl: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")
    }
    
    // MARK: - Private Function
    private func covertFormatInEpisodeItems(_ episodeItems: [Episode]) -> [Episode] {
        return episodeItems.map {
            Episode(epTitle: $0.epTitle,
                    epImgString: $0.epImgString,
                    pubDate: covertDateFormat($0.pubDate),
                    description: $0.description,
                    audioUrl: $0.audioUrl)
        }
    }
    
    // convert pubDate form 'EEE, dd MM yyyy hh:mm:ss +zzzz' to 'yyyy/MM/dd'
    private func covertDateFormat(_ dateString: String) -> String {
        let string = String(dateString.dropLast(15))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        guard let dateObj = dateFormatter.date(from: string) else { return dateString }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: dateObj)
    }
    
}

extension HomeViewModel: FeedParserResultDelegate {
    func successParsedResult(_ podcast: Podcast, _ episodeItems: [Episode]) {
        self.podcast = podcast
        self.episodeItems = covertFormatInEpisodeItems(episodeItems)
        delegate?.updateFeedData()
    }
    
    func failedParsed(_ error: Error) {
        print(error.localizedDescription)
    }
}
