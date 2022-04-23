//
//  PlayerViewModel.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/20.
//

import Foundation
import AVFoundation

protocol PodcastPlayerDelegate: AnyObject {
    func updateCurrentPlayingProgess(_ value: Float)
    func updateCurrentEpDetails(title: String, imgUrlString: String)
    func updateState(_ playing: Bool)
}

class PlayerViewModel {
    var episodeItems: [Episode] = []
    var currentEpIndex: Int = 0
    
    private var podcastPlayer: AVPlayer?
    private var currentItem: AVPlayerItem? {
        return podcastPlayer?.currentItem
    }
    private var currentItemDuration: CMTime? {
        return currentItem?.duration
    }
    
    private var timeObserverToken: Any?
    weak var delegate: PodcastPlayerDelegate?
    
    // MARK: - Initializer
    init(episodeItems: [Episode], currentEpIndex: Int) {
        self.episodeItems = episodeItems
        self.currentEpIndex = currentEpIndex
        setupPlayer()
    }
    
    deinit {
        deinitPlayer()
        print("deinit player page")
    }
    
    // MARK: - Function
    @discardableResult
    func setPlayState(_ playing: Bool) -> Bool {
        var buttonIsSelected: Bool
        if playing {
            podcastPlayer?.play()
            buttonIsSelected = true
        } else {
            podcastPlayer?.pause()
            buttonIsSelected = false
        }
        delegate?.updateState(buttonIsSelected)
        return buttonIsSelected
    }
    
    func progressBarTouchEnd(sliderValue: Float) {
        let seekToTime = convertValueToTime(sliderValue)
        playerSeekTo(seekToTime)
        updatePlayingProgress(time: seekToTime)
        setPlayState(true)
    }
    
    func playNextTrack() {
        if currentEpIndex > 0 {
            currentEpIndex -= 1
            proceedToEpisode(index: currentEpIndex)
        }
    }
    
    func playPreviousTrack() {
        if episodeItems.count - 1 > currentEpIndex {
            currentEpIndex += 1
            proceedToEpisode(index: currentEpIndex)
        }
    }
    
    // MARK: - Private Function
    private func setupPlayer() {
        guard let currentAudioUrl = URL(string: episodeItems[currentEpIndex].audioUrl) else { return }
        podcastPlayer = AVPlayer(url: currentAudioUrl)
        setPlayState(true)
        addPeriodicTimeObserver()
        observeItemPlayEnd(currentPlayerItem: currentItem)
    }
    
    private func proceedToEpisode(index: Int) {
        let epTitle = episodeItems[index].epTitle
        let epImgString = episodeItems[index].epImgString
        let audioUrl = episodeItems[index].audioUrl
        delegate?.updateCurrentEpDetails(title: epTitle, imgUrlString: epImgString)
        replaceCurrentPlayerItem(urlString: audioUrl)
    }
    
    private func replaceCurrentPlayerItem(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: url)
        DispatchQueue.main.async {
            self.podcastPlayer?.replaceCurrentItem(with: playerItem)
            self.observeItemPlayEnd(currentPlayerItem: playerItem)
            self.setPlayState(true)
        }
    }
    
    private func convertValueToTime(_ sliderValue: Float) -> CMTime {
        guard let duration = currentItemDuration else { return CMTime.zero }
        let newCurrentTime: TimeInterval = Double(sliderValue) * CMTimeGetSeconds(duration)
        return CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
    }
    
    private func playerSeekTo(_ time: CMTime) {
        guard let player = podcastPlayer else { return }
        player.seek(to: time)
    }
    
    private func updatePlayingProgress(time: CMTime) {
        guard let currentItem = currentItem else { return }
        let currentTime: CMTime = currentItem.currentTime()
        let currentDuration: CMTime = currentItem.duration
        
        let playProgress = Float(CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(currentDuration))
        delegate?.updateCurrentPlayingProgess(playProgress)
    }
    
    @objc private func didPlaybackEnd() {
        playNextTrack()
    }
    
    private func deinitPlayer() {
        podcastPlayer = nil
        timeObserverToken = nil
        removePeriodicTimeObserver()
    }
    
    // MARK: - Observer
    private func observeItemPlayEnd(currentPlayerItem: AVPlayerItem?) {
        NotificationCenter.default.addObserver(self, selector: #selector(didPlaybackEnd), name: .AVPlayerItemDidPlayToEndTime, object: currentPlayerItem)
    }
    
    private func addPeriodicTimeObserver() {
        guard let podcastPlayer = podcastPlayer else { return }
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Add time observer. Invoke closure on the main queue.
        timeObserverToken =
        podcastPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            // update player transport UI
            guard let self = self else { return }
            self.updatePlayingProgress(time: time)
        }
    }
    
    private func removePeriodicTimeObserver() {
        guard let podcastPlayer = podcastPlayer else { return }
        // If a time observer exists, remove it
        if let token = timeObserverToken {
            podcastPlayer.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
}
