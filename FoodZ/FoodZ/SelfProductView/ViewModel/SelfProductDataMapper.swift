//
//  SelfProductDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 14.05.2024.
//

import Foundation

final class SelfProductDataMapper {
    func displayData(from product: ProductSelf) -> [SelfProductSectionType] {
        var items: [SelfProductSectionType] = []
        var images: [SelfProductCellType] = []
        for imageId in product.productImagesId {
            images.append(.imagesCell(imageId: imageId))
        }
        let informationCell = InformationCellData(
            productUsername: product.productUsername,
            productName: product.productName,
            productPrice: String(product.productPrice),
            productCategory: product.productCategory,
            address: product.address
        )

        items.append(.imagesSection(images))
        items.append(.informationSection(.informationCell(informationCell)))

        return items
    }
}
