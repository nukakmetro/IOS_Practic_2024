//
//  Tabs.swift
//  FoodZ
//
//  Created by surexnx on 31.03.2024.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let title: String
    let type: String
    let items: [Product]
}

struct Product: Decodable, Hashable {
    var productDescription: String
    var productId: Int
    var productName: String
    var productPrice: Int
    var productWaitingTime: Int
    var productRating: Int
    var productUsername: String
    var productCategory: String
    var productCompound: String
    var productImages: [Image]
}

struct Image: Decodable, Hashable {
    var imageName: String
    var imageId: Int
}
