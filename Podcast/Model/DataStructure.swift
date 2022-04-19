//
//  DataStructure.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/17.
//

import Foundation

struct Podcast {
    let podcastTitle: String
    let podcastImgString: String
}

struct Episode {
    let epTitle: String
    let epImgString: String
    let pubDate: String
    let description: String
    let audioUrl: String
}
