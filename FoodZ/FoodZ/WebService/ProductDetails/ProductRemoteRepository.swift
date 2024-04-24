//
//  HomeLoadRepository.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//

import Foundation
import CoreData


protocol ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> Void))
}

protocol ProductSearchProtocol {
    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Section], Error>) -> Void))

    func getStartRecommendations(completion: @escaping ((Result<[Section], Error>) -> Void))
}

final class ProductRemoteRepository {

    // MARK: Private properties

    private var statefulNetworkService: StatefulNetworkService
    private let remoteDataSource: ProductsRemoteDataSource

    // MARK: Internal properties

    func decode() -> [Section]? {
        return Bundle.main.decode([Section].self, from: "foodz.json")
    }

    // MARK: Initialization

    init() {
        statefulNetworkService = StatefulNetworkService()
        self.remoteDataSource = ProductsRemoteDataSource(networkService: StatefulNetworkService())
    }
}

// MARK: ProductFavorietesProtocol protocol

extension ProductRemoteRepository: ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> Void)) {
        return remoteDataSource.getProducts(completion: completion)
    }
}

// MARK: ProductSearchProtocol protocol

extension ProductRemoteRepository: ProductSearchProtocol {

    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Section], Error>) -> Void)) {
        remoteDataSource.getSearchProducts(productSearchRequest: productRequest, completion: completion)
    }

    func getStartRecommendations(completion: @escaping ((Result<[Section], Error>) -> Void)) {
        remoteDataSource.getRecomendationsSearch(completion: completion)
    }
}
