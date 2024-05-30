//
//  SearchDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 12.05.2024.
//

import Foundation

final class SearchDataMapper {
    func displayData(products: [Product]) -> [SearchSectionType] {
        var sections: [SearchSectionType] = []
        var items: [SearchCellType] = []
        for product in products {
            items.append(.bodyCell(ProductCell(
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
        sections.append(.bodySection(UUID(), items))
        return sections
    }
}
