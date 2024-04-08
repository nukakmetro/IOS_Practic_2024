//
//  HomeLoadRepository.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//

import Foundation
import CoreData

class HomeLoadRepository {

    // MARK: Private properties

    // MARK: Internal properties

    func decode() -> [Section]? {
        return Bundle.main.decode([Section].self, from: "foodz.json")
    }
}
