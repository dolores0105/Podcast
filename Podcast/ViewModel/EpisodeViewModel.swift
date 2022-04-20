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
    var episodeDetail: Episode?
    
    init(podcastTitle: String?, episodeDetail: Episode?) {
        self.podcastTitle = podcastTitle
        self.episodeDetail = episodeDetail
    }
}
