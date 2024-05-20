//
//  InfoPickUpPointResponce.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

struct InfoPickUpPointResponce: Decodable {
    var pickUpPointId: Int
    var pickUpPointName: String
    var street: String
    var city: String
    var house: String
    var zipCode: String
}
