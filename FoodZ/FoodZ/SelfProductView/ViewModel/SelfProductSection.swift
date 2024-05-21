//
//  SelfProductSection.swift
//  FoodZ
//
//  Created by surexnx on 13.05.2024.
//

import Foundation

enum SelfProductSectionType: Hashable {
    case imagesSection([SelfProductCellType])
    case informationSection(SelfProductCellType)
}

enum SelfProductCellType: Hashable {
    case imagesCell(imageId: Int)
    case informationCell(InformationCellData)
}

struct SelfProductContentData {
    var cartButton: Int
    var likeButton: Bool
}

struct InformationCellData: Hashable {
    var productUsername: String
    var productName: String
    var productPrice: String
    var productCategory: String
    var address: String
}

struct ProductSelf: Decodable {
    var productDescription: String
    var productId: Int
    var productName: String
    var productPrice: Int
    var productWaitingTime: Int
    var productRating: Int
    var productCategory: String
    var productCompound: String
    var productImagesId: [Int]
    var productSavedStatus: Bool
    var productBuyStatus: Int
    var productUsername: String
    var address: String
}
