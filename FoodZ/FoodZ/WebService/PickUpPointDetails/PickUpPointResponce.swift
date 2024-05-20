//
//  PickUpPointResponce.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

struct PickUpPointResponce: Decodable {
    var pickUpPointId: Int
    var latitude: Double
    var longitude: Double
    var pickUpPointName: String
    var street: String
    var city: String
    var house: String
    var zipCode: String
}
