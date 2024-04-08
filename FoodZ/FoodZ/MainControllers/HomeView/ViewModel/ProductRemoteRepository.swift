//
//  HomeLoadRepository.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//

import Foundation
import CoreData

protocol ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> ()))
}

protocol ProductSearchProtocol {
    func getSearchProducts(inputText: String, completion: @escaping ((Result<[Section], Error>) -> ()))
    func getStartRecommendations(completion: @escaping ((Result<[Section], Error>) -> ()))
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
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> ())) {
        let sections = Bundle.main.decode([Section].self, from: "foodz.json")
        completion(.success(sections))
    }
}

// MARK: ProductSearchProtocol protocol

extension ProductRemoteRepository: ProductSearchProtocol {
    func getSearchProducts(inputText: String, completion: @escaping ((Result<[Section], Error>) -> ())) {
        let sections = Bundle.main.decode([Section].self, from: "foodz.json")
        completion(.success(sections))
    }
    
    func getStartRecommendations(completion: @escaping ((Result<[Section], Error>) -> ())) {
        let sections = Bundle.main.decode([Section].self, from: "foodz.json")
        completion(.success(sections))
    }
}
