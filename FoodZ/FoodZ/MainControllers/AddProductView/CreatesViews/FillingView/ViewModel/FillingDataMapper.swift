//
//  FillinfDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation

final class FillingDataMapper {

    var product: ProductCreator?

    func dispayData(from dataModel: ProductCreator) -> [FillingCellType] {
        var result: [FillingCellType] = []
        product = dataModel
        result.append(.oneLine(FillingData(name: "Введите название", value: dataModel.productName, error: false)))
        result.append(.oneLine(FillingData(name: "Введите цену", value: dataModel.productPrice, error: false)))
        result.append(.oneLine(FillingData(name: "Введите время создания", value: dataModel.productWaitingTime, error: false)))
        result.append(.oneLine(FillingData(name: "Введите категорию", value: dataModel.productCategory, error: false)))
        result.append(.oneLine(FillingData(name: "Введите состав", value: dataModel.productCompound, error: false)))
        result.append(.oneLine(FillingData(name: "Введите описание", value: dataModel.productDescription, error: false)))
        return result
    }

    func displayData(from data: [FillingData]) -> [FillingCellType] {
        data.map { .oneLine($0) }
    }

    func reverse(data: [FillingData]) -> ProductCreator? {
        product?.productName = data[0].value
        product?.productPrice = data[1].value
        product?.productWaitingTime = data[2].value
        product?.productCategory = data[3].value
        product?.productCompound = data[4].value
        product?.productDescription = data[5].value
        return product
    }
}
