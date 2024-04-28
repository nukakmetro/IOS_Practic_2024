//
//  ProductModul.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import Foundation

struct ProductModel: Encodable {
    var productName: String
    var productCategory: Int
    var productCompound: [String]
    var productPrice: Int
    var productDescription: String
    var productWaitingTime: Int
}
