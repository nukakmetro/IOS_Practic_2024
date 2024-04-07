//
//  SearchViewIntent.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation

enum SearchViewIntent {
    case onClose
    case proccedInputSearchText(_ text: String)
    case onReload
}
