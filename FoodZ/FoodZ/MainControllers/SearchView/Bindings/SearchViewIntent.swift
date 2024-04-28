//
//  SearchViewIntent.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation

enum SearchViewIntent {
    case onClose
    case proccesedInputSearchText(_ text: String)
    case onReload
    case onDidlLoad
    case proccesedLazyLoad
}
