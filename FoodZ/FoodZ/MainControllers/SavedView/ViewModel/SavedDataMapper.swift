//
//  SavedDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 12.05.2024.
//

import Foundation

final class SavedDataMapper {
    func displayData(products: [Product]) -> [SavedCellType] {
        var productCells: [SavedCellType] = []
        for product in products {
            productCells.append(.bodyCell(ProductCell(
                id: UUID(),
                productDescription: product.productDescription,
                productId: product.productId,
                productName: product.productName,
                productPrice: product.productPrice,
                productWaitingTime: product.productWaitingTime,
                productRating: product.productRating,
                productUsername: product.productUsername,
                productCategory: product.productCategory,
                productCompound: product.productCompound,
                productImageId: product.productImageId,
                productSavedStatus: product.productSavedStatus
            )))
        }
        return productCells
    }
}
