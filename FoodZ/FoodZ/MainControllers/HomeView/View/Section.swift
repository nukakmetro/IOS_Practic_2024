//
//  Tabs.swift
//  FoodZ
//
//  Created by surexnx on 31.03.2024.
//

import Foundation

enum HomeSectionType: Hashable {
    case headerSection(HomeCellType)
    case bodyHeaderSection(HomeCellType)
    case bodySection([HomeCellType])
}

enum HomeCellType: Hashable {
    case headerCell
    case bodyHeaderCell(ProductHeader)
    case bodyCell(ProductCell)

}

struct ProductHeader: Hashable {
    var id: UUID
    var title: String
}

struct ProductCell: Hashable {
    var cellId: UUID
    var productDescription: String
    var productId: Int
    var productName: String
    var productPrice: Int
    var productWaitingTime: Int
    var productRating: Int
    var productUsername: String
    var productCategory: String
    var productCompound: String
    var productImageId: Int
    var productSavedStatus: Bool
}

struct Section: Decodable {
    let title: String
    let products: [Product]
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
    var productImageId: Int
    var productSavedStatus: Bool
}

struct Image: Decodable, Hashable {
    var imageName: String
    var imageId: Int
}
