//
//  CartDataSource.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

final class CartDataSource {

    // MARK: Private properties

    private let networkService: NetworkServiceProtocol

    // MARK: Initialization

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Internal methods

    func getCart(completion: @escaping (Result<CartResponce, Error>) -> Void) {
        let target = Target(path: "/user/cart", method: .get, setParametresFromEncodable: nil, role: .user)
        networkService.sendRequest(target: target, responseType: CartResponce.self, completion: completion)
    }

    func reduceCart(cartId: Int, completion: @escaping (Result<CartRecountResponce, Error>) -> Void) {
        let target = Target(path: "/user/cart/reduce", method: .post, setParametresFromEncodable: cartId, role: .user)
        networkService.sendRequest(target: target, responseType: CartRecountResponce.self, completion: completion)
    }

    func increaseCart(cartId: Int, completion: @escaping (Result<CartRecountResponce, Error>) -> Void) {
        let target = Target(path: "/user/cart/increase", method: .post, setParametresFromEncodable: cartId, role: .user)
        networkService.sendRequest(target: target, responseType: CartRecountResponce.self, completion: completion)
    }

    func removeCart(cartId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/cart/remove", method: .post, setParametresFromEncodable: cartId, role: .user)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }

    func insertCart(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/cart/insert", method: .post, setParametresFromEncodable: productId, role: .user)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }

    func toggleLike(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/product/like", method: .post, setParametresFromEncodable: productId, role: .user)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }
}
