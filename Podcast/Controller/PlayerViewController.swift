//
//  PlayerViewController.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/20.
//

import UIKit
import SnapKit
import SwiftUI

class PlayerViewController: UIViewController {
    
    // MARK: - Property
    var viewModel: PlayerViewModel?
    
    // MARK: - Initializer
    convenience init(viewModel: PlayerViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configViews()
        loadDetails()
        viewModel?.delegate = self
    }
    
    // MARK: - Target Action
    @objc func handleProgressBarTouchBegan(_ sender: UISlider) {
        guard let viewModel = viewModel else { return }
        playPauseButton.isSelected = viewModel.setPlayState(false)
    }
    
    @objc func handleProgressBarTouchEnd(_ sender: UISlider) {
        guard let viewModel = viewModel else { return }
        playPauseButton.isSelected = viewModel.setPlayState(true)
        viewModel.progressBarTouchEnd(sliderValue: sender.value)
    }
    
    @objc func handleProgressBarValueChanged(_ sender: UISlider) {
        guard let viewModel = viewModel else { return }
        playPauseButton.isSelected = viewModel.setPlayState(false)
    }
    
    @objc func togglePlayPause(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        sender.isSelected.toggle()
        playPauseButton.isSelected = viewModel.setPlayState(sender.isSelected)
    }
    
    @objc func tapNextTrack(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.playNextTrack()
    }
    
    @objc func tapPreviousTrack(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.playPreviousTrack()
    }
    
    // MARK: - Private Function
    private func loadDetails() {
        guard let viewModel = viewModel else { return }
        episodeImageView.loadImage(viewModel.episodeItems[viewModel.currentEpIndex].epImgString)
        epTitleLabel.text = viewModel.episodeItems[viewModel.currentEpIndex].epTitle
        playPauseButton.isSelected = viewModel.setPlayState(true)
    }
    
    private func configViews() {
        view.addSubview(episodeImageView)
        episodeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(12)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(episodeImageView.snp.width)
        }
        
        view.addSubview(epTitleLabel)
        epTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(episodeImageView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(12)
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(previousTrackButton)
        stackView.addArrangedSubview(playPauseButton)
        stackView.addArrangedSubview(nextTrackButton)
        stackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.left.right.equalToSuperview().inset(12)
        }
        
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalTo(stackView.snp.top).offset(-10)
        }
    }
    
    // MARK: - UI
    private lazy var episodeImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        imgView.backgroundColor = .yellow
        return imgView
    }()
    
    private lazy var epTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "Ep. 1 text"
        return label
    }()
    
    private lazy var progressBar: UISlider = {
        let bar = UISlider()
        bar.minimumTrackTintColor = .blue
        bar.maximumTrackTintColor = .gray
        bar.maximumValue = 1
        bar.minimumValue = 0
        bar.addTarget(self, action: #selector(handleProgressBarTouchBegan), for: .touchDown)
        bar.addTarget(self, action: #selector(handleProgressBarTouchEnd), for: [.touchUpInside, .touchUpOutside])
        bar.addTarget(self, action: #selector(handleProgressBarValueChanged), for: .valueChanged)
        return bar
    }()
    
    private lazy var playPauseButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 64)
        let playImage = UIImage(systemName: "play.circle", withConfiguration: configuration)
        let pauseImage = UIImage(systemName: "pause.circle", withConfiguration: configuration)
        let button = UIButton()
        button.setImage(playImage, for: .normal)
        button.setImage(pauseImage, for: .selected)
        button.addTarget(self, action: #selector(togglePlayPause), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextTrackButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 64)
        let forwardImage = UIImage(systemName: "forward", withConfiguration: configuration)
        button.setImage(forwardImage, for: .normal)
        button.addTarget(self, action: #selector(tapNextTrack), for: .touchUpInside)
        return button
    }()
    
    private lazy var previousTrackButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 64)
        let backwardImage = UIImage(systemName: "backward", withConfiguration: configuration)
        button.setImage(backwardImage, for: .normal)
        button.addTarget(self, action: #selector(tapPreviousTrack), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
}

// MARK: - PodcastPlayerDelegate
extension PlayerViewController: PodcastPlayerDelegate {
    func updateCurrentPlayingProgess(_ value: Float) {
        progressBar.value = value
    }
    
    func updateCurrentEpDetails(title: String, imgUrlString: String) {
        epTitleLabel.text = title
        episodeImageView.loadImage(imgUrlString)
    }
    
    func updateState(_ playing: Bool) {
        playPauseButton.isSelected = playing
    }
}
