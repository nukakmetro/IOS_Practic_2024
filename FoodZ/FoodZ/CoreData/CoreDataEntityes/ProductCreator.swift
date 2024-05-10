//
//  ProductCreator.swift
//  FoodZ
//
//  Created by surexnx on 09.05.2024.
//

import Foundation

class ProductCreator {
    var productCategory: String?
    var productCompound: String?
    var productDescription: String?
    var productId: UUID
    var productName: String?
    var productPrice: String?
    var productWaitingTime: String?
    var images: Set<UUID>

    init(productId: UUID) {
        self.productId = productId
        self.images = []
    }

    init(productCategory: String? = nil, productCompound: String? = nil, productDescription: String? = nil, productId: UUID, productName: String? = nil, productPrice: String? = nil, productWaitingTime: String? = nil, images: Set<UUID>) {
        self.productCategory = productCategory
        self.productCompound = productCompound
        self.productDescription = productDescription
        self.productId = productId
        self.productName = productName
        self.productPrice = productPrice
        self.productWaitingTime = productWaitingTime
        self.images = images
    }

    func mapToRequest() -> ProductRequest {
        ProductRequest(
            productName: productName,
            productPrice: Int(productPrice ?? "1"),
            productWaitingTime: Int(productWaitingTime ?? "1"),
            productCategory: productCategory,
            productCompound: productCompound,
            productDescription: productDescription
        )
    }
}
