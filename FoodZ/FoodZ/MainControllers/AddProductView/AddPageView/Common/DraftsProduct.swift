//
//  DraftsProduct.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation

struct DraftsProduct: Hashable {
    var id: UUID
    var name: String?
    var price: String?
    var image: Data?
    var time: String?
}
