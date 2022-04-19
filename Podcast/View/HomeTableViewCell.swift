//
//  HomeTableViewCell.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/19.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {

    // MARK: - UI
    private lazy var epImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var epTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .medium(size: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var epPubDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .medium(size: 11)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initailizer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    func reloadCell(imgString: String, title: String, pubDate: String) {
        epImageView.addIndicator()
        epImageView.loadImage(imgString, placeHolder: nil)
        epTitle.text = title
        epPubDateLabel.text = pubDate
    }
    
    // MARK: - Private Function
    private func configCell() {
        contentView.addSubview(epImageView)
        epImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview().inset(12)
            make.height.width.equalTo(64)
        }
        
        contentView.addSubview(epTitle)
        epTitle.snp.makeConstraints { make in
            make.top.equalTo(epImageView).inset(4)
            make.left.equalTo(epImageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(epPubDateLabel)
        epPubDateLabel.snp.makeConstraints { make in
            make.left.equalTo(epTitle)
            make.bottom.equalTo(epImageView).inset(4)
            make.right.equalToSuperview().inset(12)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        epImageView.cancelDownload()
        epTitle.text = ""
        epPubDateLabel.text = ""
    }
}
