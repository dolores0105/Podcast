//
//  HomeViewController.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/17.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Property
    private var viewModel: HomeViewModel = HomeViewModel()
    
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        viewModel.parseFeed()
        viewModel.delegate = self
    }
    
    // MARK: - Private Function
    private func configTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let episodeItems = viewModel.episodeItems else { return 0 }
        return episodeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell,
              let episodesItem = viewModel.episodeItems?[indexPath.row] else {
                  return UITableViewCell()
              }
        cell.selectionStyle = .none
        cell.reloadCell(imgString: episodesItem.epImgString, title: episodesItem.epTitle, pubDate: episodesItem.pubDate)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let podcast = viewModel.podcast else { return nil }
        let headerView = UIImageView()
        headerView.addIndicator()
        headerView.loadImage(podcast.podcastImgString, placeHolder: nil)
        headerView.clipsToBounds = true
        headerView.contentMode = .scaleAspectFill
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeVC = EpisodeViewController(viewModel: .init(podcastTitle: viewModel.podcast?.podcastTitle, episodeItems: viewModel.episodeItems, episodeIndex: Int(indexPath.row)))
        navigationController?.pushViewController(episodeVC, animated: true)
    }
}

// MARK: - ParseFeedDelegate
extension HomeViewController: ParseFeedDelegate {
    func updateFeedData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
