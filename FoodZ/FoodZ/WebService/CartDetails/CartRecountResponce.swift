//
//  CartRecountResponce.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

struct CartRecountResponce: Decodable {
    var cartItemId: Int
    var cartItemPrice: Int
    var cartItemQuantity: Int
    var totalPrice: Int
}
