//
//  HomeDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 11.05.2024.
//

import Foundation

final class HomeDataMapper {
    func displayData(sections: [Section]) -> [HomeSectionType] {
        var displaySection: [HomeSectionType] = []

        for section in sections {
            displaySection.append(.bodyHeaderSection(id: UUID(), .bodyHeaderCell(ProductHeader(id: UUID(), title: section.title))))
            var products: [HomeCellType] = []
            for product in section.products {
                products.append(.bodyCell(ProductCell(
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
            displaySection.append(.bodySection(id: UUID(), products))
        }
        return displaySection
    }
}
