//
//  FeedParser.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/17.
//

import Foundation

protocol FeedParserResultDelegate: AnyObject {
    func successParsedResult(_ podcast: Podcast, _ episodeItems: [Episode])
    func failedParsed(_ error: Error)
}

class FeedParser: NSObject {
    enum RssTag: String {
        case item = "item"
        case title = "title"
        case podcastImageUrl = "url"
        case epPubDate = "pubDate"
        case epDescription = "description"
        case epAudioEnclosure = "enclosure"
        case epImage = "itunes:image"
    }
    
    private var podcast: Podcast?
    private var episodeItems: [Episode] = []
    
    private var currentElement: String = ""
    private var isPodcastTitleFound: Bool = false
    private var isPodcastImgFound: Bool = false
    private var podcastTitle: String = "" {
        didSet {
            podcastTitle = podcastTitle.trimmingCharacters(in: .whitespacesAndNewlines)
            isPodcastTitleFound = !(podcastTitle.isEmpty)
        }
    }
    private var podcastImageString: String = "" {
        didSet {
            podcastImageString = podcastImageString.trimmingCharacters(in: .whitespacesAndNewlines)
            isPodcastImgFound = !(podcastImageString.isEmpty)
        }
    }
    private var currentEpTitle: String = ""
    private var currentEpPubDate: String = ""
    private var currentEpDescription: String = ""
    private var currentEpAudioUrl: String = ""
    private var currentEpImage: String = ""
    
    weak var delegate: FeedParserResultDelegate?
    
    func parseFeed(feedUrlString: String) {
        guard let feedUrl = URL(string: feedUrlString) else { return }
        let request = URLRequest(url: feedUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
}

extension FeedParser: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        episodeItems = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == RssTag.item.rawValue {
            currentEpTitle = ""
            currentEpPubDate = ""
            currentEpDescription = ""
            currentEpAudioUrl = ""
            currentEpImage = ""
        }
        
        if currentElement == RssTag.epAudioEnclosure.rawValue {
            if let audioUrl = attributeDict["url"] {
                currentEpAudioUrl = audioUrl
            }
        }
        
        if currentElement == RssTag.epImage.rawValue && isPodcastImgFound {
            if let href = attributeDict["href"] {
                currentEpImage = href
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case RssTag.title.rawValue:
            if isPodcastTitleFound {
                currentEpTitle += string
            } else {
                podcastTitle += string
            }
        case RssTag.podcastImageUrl.rawValue: podcastImageString += string
        case RssTag.epPubDate.rawValue:
            if isPodcastTitleFound && isPodcastImgFound {
                currentEpPubDate += string
            }
        case RssTag.epDescription.rawValue:
            if isPodcastTitleFound && isPodcastImgFound {
                currentEpDescription += string
            }
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == RssTag.item.rawValue {
            if let titleIndex = currentEpTitle.range(of: "\n")?.lowerBound,
               let pubDateIndex = currentEpPubDate.range(of: "\n")?.lowerBound {
                let puredEpTitle = String(currentEpTitle[..<titleIndex])
                let puredEpPubDate = String(currentEpPubDate[..<pubDateIndex])
                podcast = Podcast(podcastTitle: podcastTitle, podcastImgString: podcastImageString)
                let episodeItem = Episode(epTitle: puredEpTitle, epImgString: currentEpImage, pubDate: puredEpPubDate, description: currentEpDescription, audioUrl: currentEpAudioUrl)
                episodeItems.append(episodeItem)
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        guard let podcast = podcast else { return }
        delegate?.successParsedResult(podcast, episodeItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        delegate?.failedParsed(parseError)
    }
}
