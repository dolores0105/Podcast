//
//  HomeViewModel.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/19.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func reloadParserData()
}

class HomeViewModel: NSObject {
    // MARK: - Properties
    var podcast: Podcast?
    var episodeItems: [Episode]? // semi-finished property
    var convertedEpisodeItems: [Episode] = [] // finished business logic conversion
    private var rssParser: RssParser = RssParser()
    private let feedUrlString: String = "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss"
    
    weak var delegate: HomeViewModelDelegate?
    
    // MARK: - Initializer
    override init() {
        super.init()
        rssParser.delegate = self
    }
    
    // MARK: - Function
    /* For Controller to call when to parse */
    func parseFeed() {
        rssParser.parseFeed(feedUrlString)
    }
    
    // MARK: - Private Function
    /* Convert the date formate of pubDate for each episode in Episode type of array */
    private func covertFormatInEpisodeItems(_ episodeItems: [Episode]) -> [Episode] {
        return episodeItems.map {
            Episode(epTitle: $0.epTitle,
                    initWithEpImgString: $0.epImgString,
                    initWithPubDate: covertDateFormat($0.pubDate),
                    initWithEpDescription: $0.epDescription,
                    initWithAudioUrl: $0.audioUrl)
        }
    }
    
    /* Convert date formate of the date string from 'EEE, dd MM yyyy hh:mm:ss +zzzz' to 'yyyy/MM/dd' */
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
    /* Catch result parsed by model,
     and call 'covertFormatInEpisodeItems' method to deal with the business logic */
    func successParsedResult(_ podcast: Podcast, episodeItems: [Episode]) {
        self.podcast = podcast
        self.episodeItems = episodeItems
        if let unwrapEpisodeItems = self.episodeItems {
            self.convertedEpisodeItems = covertFormatInEpisodeItems(unwrapEpisodeItems)
        }
        delegate?.reloadParserData()
    }
    
    func failedParsed(_ error: Error) {
        print(error.localizedDescription)
    }
}
