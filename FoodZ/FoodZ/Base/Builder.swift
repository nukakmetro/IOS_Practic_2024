//
//  Builder.swift
//  Foodp2p
//
//  Created by surexnx on 19.03.2024.
//

import Foundation

protocol Builder {
    associatedtype T
    func build() -> T
}
