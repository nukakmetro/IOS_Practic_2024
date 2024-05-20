//
//  AppColor.swift
//  FoodZ
//
//  Created by surexnx on 26.03.2024.
//

import Foundation
import UIKit

public enum AppColor {
    case primary
    case secondary
    case accent
    case background
    case title
    case cartBackground

    var lightColor: UIColor {
        switch self {
        case .primary:
            UIColor.orange
        case .secondary:
            UIColor.white
        case .accent:
            UIColor.brown
        case .background:
            UIColor.white
        case .title:
            UIColor.black
        case .cartBackground:
            UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        }

    }

    var darkColor: UIColor {
        switch self {
        case .primary:
            UIColor.orange
        case .secondary:
            UIColor.white
        case .accent:
            UIColor.red
        case .background:
            UIColor.black
        case .title:
            UIColor.white
        case .cartBackground:
            UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        }
    }

    var color: UIColor {
        return UIColor { traitcollection in
            return traitcollection.userInterfaceStyle == .dark ? self.darkColor : self.lightColor
        }
    }
}
