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
