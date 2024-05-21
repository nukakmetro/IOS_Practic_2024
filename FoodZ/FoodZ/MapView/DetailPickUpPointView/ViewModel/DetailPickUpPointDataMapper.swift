//
//  DetailPickUpPointDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

final class DetailPickUpPointDataMapper {
    func displayData(data: InfoPickUpPointResponce) -> DetailPickUpPointViewData {
        return DetailPickUpPointViewData(
            pickUpPointName: data.pickUpPointName,
            street: data.street,
            city: data.city,
            house: data.house,
            zipCode: data.zipCode
        )
    }
}
