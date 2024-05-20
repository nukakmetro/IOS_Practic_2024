//
//  CartProductResponce.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

struct CartProductResponce: Decodable {
    var productId: Int
    var cartItemId: Int
    var productPrice: Int
    var productImageId: Int
    var productName: String
    var productCategory: String
    var productCompound: String
    var productDescription: String
    var productSavedStatus: Bool
    var quantity: Int
}
