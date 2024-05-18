//
//  CartResponce.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

struct CartResponce: Decodable {
    let cartItems: [CartProductResponce]
    let totalPrice: Int
}
