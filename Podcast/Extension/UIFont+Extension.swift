//
//  UIFont+Extension.swift
//  Podcast
//
//  Created by 林宜萱 on 2022/4/19.
//

import UIKit

enum FontName: String {
    case regular = "PingFangTC-Regular"
    case medium = "PingFangTC-Medium"
    case semiBold = "PingFangTC-Semibold"
}

extension UIFont {

    static func regular(size: CGFloat) -> UIFont? {
        return UIFont(name: FontName.regular.rawValue, size: size)
    }

    static func medium(size: CGFloat) -> UIFont? {
        return UIFont(name: FontName.medium.rawValue, size: size)
    }

    static func semiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: FontName.semiBold.rawValue, size: size)
    }
}
