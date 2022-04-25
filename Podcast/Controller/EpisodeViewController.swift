//
//  EpisodeViewController.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/20.
//

import UIKit
import SnapKit

class EpisodeViewController: UIViewController {
    // MARK: - UI
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var contenView: UIView = {
        return UIView()
    }()
    
    private lazy var episodeImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 10
        return imgView
    }()
    
    private lazy var podcastTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium(size: 20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .regular(size: 12)
        textView.textColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        return textView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 160, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: largeConfig), for: .normal)
        button.addTarget(self, action: #selector(tapPlay), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Property
    var viewModel: EpisodeViewModel?
    
    // MARK: - Initializer
    convenience init(viewModel: EpisodeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configViews()
        loadDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private Function
    private func loadDetails() {
        guard let viewModel = viewModel,
              let episodeItems = viewModel.episodeItems,
              let episodeIndex = viewModel.episodeIndex else {
                  return
              }
        episodeImageView.loadImage(episodeItems[episodeIndex].epImgString)
        podcastTitleLabel.text = viewModel.podcastTitle
        episodeTitleLabel.text = episodeItems[episodeIndex].epTitle
        descriptionTextView.text = episodeItems[episodeIndex].epDescription
    }
    
    private func configViews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        scrollView.addSubview(contenView)
        contenView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(view)
        }
        
        contenView.addSubview(episodeImageView)
        episodeImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(episodeImageView.snp.width)
        }
        
        episodeImageView.addSubview(podcastTitleLabel)
        podcastTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(40)
            make.left.right.equalToSuperview().inset(12)
        }
        
        episodeImageView.addSubview(episodeTitleLabel)
        episodeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(podcastTitleLabel).offset(64)
            make.left.equalTo(podcastTitleLabel.snp.left)
            make.right.equalTo(podcastTitleLabel.snp.right)
        }
        
        contenView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(episodeImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        contenView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(160)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Target Action
    @objc func tapPlay(_ sender: UIButton) {
        guard let viewModel = viewModel,
              let episodeItems = viewModel.episodeItems,
              let episodeIndex = viewModel.episodeIndex else {
            return
        }
        let playerVC = PlayerViewController(viewModel: .init(episodeItems: episodeItems, currentEpIndex: episodeIndex))
        navigationController?.pushViewController(playerVC, animated: true)
    }
}
