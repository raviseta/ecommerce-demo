//
//  AppColor.swift
//
//  Created by Ravi Seta on 26/01/25.
//

import UIKit

public enum AppColor {
    case gray30
    case primaryTextColor
    case grayBackground
    case theme
}

public extension UIColor {
    static func getAppColor(_ type : AppColor) -> UIColor {
        switch type {
        case .gray30:
            return UIColor.init(dynamicProvider: { trait in
                return trait.userInterfaceStyle == .light ? UIColor(hexString: "#FAFAFA") : UIColor(hexString: "#313131")
            })
        case .primaryTextColor:
            return UIColor.init(dynamicProvider: { trait in
                return trait.userInterfaceStyle == .light ? UIColor(hexString: "#313131") : UIColor.white
            })
        case .grayBackground:
            return UIColor.init(dynamicProvider: { trait in
                return trait.userInterfaceStyle == .light ? UIColor.init(hexString: "F7F7F7") : UIColor.init(hexString: "#1a1110")
            })
        case .theme:
                return  UIColor(hexString: "#2096F3")
        }
    }
}
