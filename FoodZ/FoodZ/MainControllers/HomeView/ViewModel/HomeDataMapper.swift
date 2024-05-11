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
            displaySection.append(.bodyHeaderSection(.bodyHeaderCell(title: section.title)))
            var products: [HomeCellType] = []
            for product in section.products {
                products.append(.bodyCell(product))
            }
            displaySection.append(.bodySection(products))
        }
        return displaySection
    }
}
