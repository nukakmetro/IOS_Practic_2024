//
//  HomeLoadRepository.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//

import Foundation
import CoreData

protocol ProductFavorietesProtocol {
    func getFavoritesProducts() -> [Section]?
}

protocol ProductSearchProtocol {
    func getSearchProducts(_ inputText: String) -> [Section]?
    func getStartRecommendations() -> [Section]?
}

class ProductRemoteRepository {

    // MARK: Private properties

    // MARK: Internal properties

    func decode() -> [Section]? {
        return Bundle.main.decode([Section].self, from: "foodz.json")
    }
}

// MARK: ProductFavorietesProtocol protocol

extension ProductRemoteRepository: ProductFavorietesProtocol {
    func getFavoritesProducts() -> [Section]? {
        return Bundle.main.decode([Section].self, from: "foodz.json")
    }
}

// MARK: ProductSearchProtocol protocol

extension ProductRemoteRepository: ProductSearchProtocol {
    func getSearchProducts(_ inputText: String) -> [Section]? {
        return nil
    }

    func getStartRecommendations() -> [Section]? {
        return nil
    }
}
