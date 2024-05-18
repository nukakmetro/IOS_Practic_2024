//
//  CartRepository.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

protocol CartProtocol {
    func getCart(completion: @escaping (Result<CartResponce, Error>) -> Void)
    func increaseCart(cartId: Int, completion: @escaping (Result<CartRecountResponce, Error>) -> Void)
    func reduceCart(cartId: Int, completion: @escaping (Result<CartRecountResponce, Error>) -> Void)
    func removeCart(cartId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func insertCart(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class CartRepository {

    // MARK: Private properties

    private let dataSource: CartDataSource

    // MARK: Initialization

    init() {
        let statefulNetworkService = StatefulNetworkService()
        self.dataSource = CartDataSource(networkService: statefulNetworkService)
    }
}

// MARK: - CartProtocol

extension CartRepository: CartProtocol {
    func getCart(completion: @escaping (Result<CartResponce, Error>) -> Void) {
        dataSource.getCart(completion: completion)
    }

    func increaseCart(cartId: Int, completion: @escaping (Result<CartRecountResponce, Error>) -> Void) {
        dataSource.increaseCart(cartId: cartId, completion: completion)
    }

    func reduceCart(cartId: Int, completion: @escaping (Result<CartRecountResponce, Error>) -> Void) {
        dataSource.reduceCart(cartId: cartId, completion: completion)
    }

    func removeCart(cartId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        dataSource.removeCart(cartId: cartId, completion: completion)
    }

    func insertCart(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        dataSource.insertCart(productId: productId, completion: completion)
    }
}
