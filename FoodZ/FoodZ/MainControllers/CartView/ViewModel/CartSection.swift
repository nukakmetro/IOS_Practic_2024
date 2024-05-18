//
//  Section.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

enum CartSectionType: Hashable {
    case bodySection([CartCellType])
}

enum CartCellType: Hashable {
    case bodyICell(CartProduct)
}

struct CartProduct: Hashable {
    var productId: Int
    var cartItemId: Int
    var productPrice: String
    var productImageId: Int
    var productName: String
    var productCategory: String
    var productCompound: String
    var productDescription: String
    var productSavedStatus: Bool
    var quantity: String
}
