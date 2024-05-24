//
//  CartPayResponce.swift
//  FoodZ
//
//  Created by surexnx on 22.05.2024.
//

import Foundation

struct CartCreateOrderResponce: Decodable {
    var totalPrice: Int
    var infoAddressCarts: [CartInfoAddressResponce]
}

struct CartInfoAddressResponce: Decodable {
    var address: String
    var price: Int
    var cartItems: [CartProductResponce]
}
