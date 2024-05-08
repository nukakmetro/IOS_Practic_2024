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

protocol AddProductProtocol {
    func sendProduct(product: ProductRequest, images: [Data], completion: @escaping (Result<Bool, Error>) -> Void)
}

protocol ProductSearchProtocol {
    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Product], Error>) -> Void))
    func getStartRecommendations(completion: @escaping ((Result<[Product], Error>) -> Void))
}

final class ProductRepository {

    // MARK: Private properties

    private let remoteDataSource: ProductsRemoteDataSource

    // MARK: Initialization

    init() {
        let statefulNetworkService = StatefulNetworkService()
        self.remoteDataSource = ProductsRemoteDataSource(networkService: statefulNetworkService)
    }
}

// MARK: - ProductFavorietesProtocol protocol

extension ProductRepository: ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> Void)) {
        return remoteDataSource.getProducts(completion: completion)
    }
}

// MARK: - ProductSearchProtocol protocol

extension ProductRepository: ProductSearchProtocol {

    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getSearchProducts(productSearchRequest: productRequest, completion: completion)
    }

    func getStartRecommendations(completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getRecomendationsSearch(completion: completion)
    }
}

import UIKit

// MARK: - AddProductProtocol protocol

extension ProductRepository: AddProductProtocol {
    func sendProduct(product: ProductRequest, images: [Data], completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteDataSource.sendProduct(product: product, images: images, completion: completion)
    }
}
