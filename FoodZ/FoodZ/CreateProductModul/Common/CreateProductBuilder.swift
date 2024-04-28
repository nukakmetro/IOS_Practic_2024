//
//  ProductBuilder.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import Foundation

enum Category: String {
    case homemadeFood = "Домашняя еда"
    case fastFood = "Фастфуд"

    func toInt() -> Int {
        switch self {
        case .homemadeFood:
            return 0
        case .fastFood:
            return 1
        }
    }
}

extension Category {
    static func fromString(_ string: String) -> Category? {
        return Category(rawValue: string)
    }
}
enum CreateState {
    case category
}

class CreateProductBuilder {
    private var productName: String?
    private var productCategory: Category?
    private var productCompound: [String]?
    private var productImage: [Image]?
    private var productPrice: Int?
    private var productDescription: String?
    private var productWaitingTime: Int?


    func addProductName(_ name: String) -> Self {
           self.productName = name
           return self
       }

    func addProductCategory(_ category: String) -> Self {
        self.productCategory = Category.fromString(category)
        return self
    }
    func addProductCompound(_ compound: [String]) -> Self {
        self.productCompound = compound
        return self
    }
    func addProductImage(_ images: [Image]) -> Self {
        self.productImage = images
        return self
    }
    func addProductPrice(_ price: Int) -> Self {
        self.productPrice = price
        return self
    }
    func addProductDescription(_ description: String) -> Self {
        self.productDescription = description
        return self
    }
    func addProductWaitingTime(_ waitingTime: Int) -> Self {
        self.productWaitingTime = waitingTime
        return self
    }

    func build() -> ProductModel {
        return ProductModel(
            productName: self.productName ?? "new",
            productCategory: self.productCategory?.toInt() ?? 0,
            productCompound: self.productCompound ?? [],
            productPrice: self.productPrice ?? 0,
            productDescription: self.productDescription ?? "",
            productWaitingTime: self.productWaitingTime ?? 0
        )
    }
}


