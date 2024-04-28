//
//  ProductSearchRequest.swift
//  FoodZ
//
//  Created by surexnx on 22.04.2024.
//

import Foundation

struct ProductSearchRequest: Encodable {
    private let searchString: String
    private let limit: Int
    private let offset: Int

    init(searchString: String, limit: Int, offset: Int) {
        self.searchString = searchString
        self.limit = limit
        self.offset = offset
    }
}
