//
//  AddingProductInput.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import Foundation

protocol CreateProductInput: AnyObject {
    func proccesedCarryOutData(_ builder: CreateProductBuilder)
}
