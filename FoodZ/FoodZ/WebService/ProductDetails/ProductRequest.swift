//
//  ProductRequest.swift
//  FoodZ
//
//  Created by surexnx on 07.05.2024.
//

import Foundation

struct ProductRequest: Encodable {
    var productName: String?
    var productPrice: Int?
    var productWaitingTime: Int?
    var productCategory: String?
    var productCompound: String?
    var productDescription: String?
}
