//
//  KingFisherWrapper.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/19.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String, placeHolder: UIImage? = nil) {
        guard let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    func cancelDownload() {
        self.kf.cancelDownloadTask()
    }
    
    func addIndicator() {
        self.kf.indicatorType = .activity
    }
}
