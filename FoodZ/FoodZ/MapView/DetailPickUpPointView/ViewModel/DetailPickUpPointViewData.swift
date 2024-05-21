//
//  DetailPickUpPointViewData.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

struct DetailPickUpPointViewData {
    var pickUpPointName: String
    var address: String
    var zipCode: String

    init(pickUpPointName: String, street: String, city: String, house: String, zipCode: String) {
        self.pickUpPointName = pickUpPointName
        self.address = city + ", " + street + ", " + house
        self.zipCode = zipCode
    }
}
