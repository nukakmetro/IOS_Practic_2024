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
        }
    }

    var color: UIColor {
        return UIColor { traitcollection in
            return traitcollection.userInterfaceStyle == .dark ? self.darkColor : self.lightColor
        }
    }
}
