//
//  EpisodeViewModel.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/20.
//

import Foundation

class EpisodeViewModel {
    //MARK: - Properties
    var podcastTitle: String?
    var episodeItems: [Episode]?
    var episodeIndex: Int?
    
    init(podcastTitle: String?, episodeItems: [Episode]?, episodeIndex: Int?) {
        self.podcastTitle = podcastTitle
        self.episodeItems = episodeItems
        self.episodeIndex = episodeIndex
    }
}
