//
//  AddImageIntent.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation
import UIKit

enum AddImageIntent {
    case onDidLoad
    case onLoad
    case onClose
    case onReload
    case proccesedTappedSendProduct
    case proccesedAddImage(_ image: UIImage)
    case proccesedTappedSaveButton
    case proccesedTappedDeleteImage(id: UUID)
}
