//
//  HomeLoadRepository.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//

import Foundation

protocol ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> Void))
}

protocol ProductSearchProtocol {
    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Product], Error>) -> Void))

    func getStartRecommendations(completion: @escaping ((Result<[Product], Error>) -> Void))
}

final class ProductRepository {

    // MARK: Private properties

    private var statefulNetworkService: StatefulNetworkService
    private let remoteDataSource: ProductsRemoteDataSource

    // MARK: Initialization

    init() {
        statefulNetworkService = StatefulNetworkService()
        self.remoteDataSource = ProductsRemoteDataSource(networkService: StatefulNetworkService())
    }
}

// MARK: ProductFavorietesProtocol protocol

extension ProductRepository: ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> Void)) {
        return remoteDataSource.getProducts(completion: completion)
    }
}

// MARK: ProductSearchProtocol protocol

extension ProductRepository: ProductSearchProtocol {

    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getSearchProducts(productSearchRequest: productRequest, completion: completion)
    }

    func getStartRecommendations(completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getRecomendationsSearch(completion: completion)
    }
}
