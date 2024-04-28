//
//  AddingProductViewModelingProtocol.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import Foundation

protocol CreateProductViewModeling: UIKitViewModel where State == CreateProductState, Intent == CreateProductIntent {}
