//
//  HomeLoadRepository.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//

import Foundation

protocol ProductSavedProtocol {
    func getSaveProducts(completion: @escaping ((Result<[Product], Error>) -> Void))
}

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

protocol ProductToggleLikeProtocol {
    func proccesedTappedLikeButton(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
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

// MARK: - ProductFavorietesProtocol

extension ProductRepository: ProductFavorietesProtocol {
    func getFavoritesProducts(completion: @escaping ((Result<[Section], Error>) -> Void)) {
        return remoteDataSource.getProducts(completion: completion)
    }
}

// MARK: - ProductSearchProtocol

extension ProductRepository: ProductSearchProtocol {

    func getSearchProducts(productRequest: ProductSearchRequest, completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getSearchProducts(productSearchRequest: productRequest, completion: completion)
    }

    func getStartRecommendations(completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getRecomendationsSearch(completion: completion)
    }
}

import UIKit

// MARK: - AddProductProtocol

extension ProductRepository: AddProductProtocol {
    func sendProduct(product: ProductRequest, images: [Data], completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteDataSource.sendProduct(product: product, images: images, completion: completion)
    }
}

// MARK: - ProductToggleLikeProtocol

extension ProductRepository: ProductToggleLikeProtocol {
    func proccesedTappedLikeButton(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteDataSource.toggleLike(productId: productId, completion: completion)
    }
}

// MARK: - ProductSavedProtocol

extension ProductRepository: ProductSavedProtocol {
    func getSaveProducts(completion: @escaping ((Result<[Product], Error>) -> Void)) {
        remoteDataSource.getSavedProducts(completion: completion)
    }
}
