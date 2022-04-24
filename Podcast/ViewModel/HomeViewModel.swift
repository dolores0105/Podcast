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

class HomeViewModel: NSObject {
    // MARK: - Properties
    var podcast: Podcast?
    var episodeItems: [Episode]?
    private var rssParser: RssParser = RssParser()
    private let feedUrlString: String = "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss"
    
    weak var delegate: UpdateParserDataDelegate?
    
    // MARK: - Initializer
    override init() {
        super.init()
        rssParser.delegate = self
    }
    
    // MARK: - Function
    func parseFeed() {
        rssParser.parseFeed(feedUrlString)
    }
    
    // MARK: - Private Function
    private func covertFormatInEpisodeItems(_ episodeItems: [Episode]) -> [Episode] {
        return episodeItems.map {
            Episode(epTitle: $0.epTitle,
                    initWithEpImgString: $0.epImgString,
                    initWithPubDate: covertDateFormat($0.pubDate),
                    initWithEpDescription: $0.epDescription,
                    initWithAudioUrl: $0.audioUrl)
        }
    }
    
    // convert pubDate form 'EEE, dd MM yyyy hh:mm:ss +zzzz' to 'yyyy/MM/dd'
    private func covertDateFormat(_ dateString: String) -> String {
        let string = String(dateString.dropLast(15))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        guard let dateObj = dateFormatter.date(from: string) else { return dateString }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: dateObj)
    }
    
}

extension HomeViewModel: RssParserDelegate {
    func successParsedResult(_ podcast: Podcast, episodeItems: [Episode]) {
        self.podcast = podcast
        self.episodeItems = covertFormatInEpisodeItems(episodeItems)
        delegate?.updateFeedData()
    }
    
    func failedParsed(_ error: Error) {
        print(error.localizedDescription)
    }
}
