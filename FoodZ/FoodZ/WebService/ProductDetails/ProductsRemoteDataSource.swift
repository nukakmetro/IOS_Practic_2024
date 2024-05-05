//
//  File.swift
//  FoodZ
//
//  Created by surexnx on 17.04.2024.
//

import Foundation
final class ProductsRemoteDataSource {

    // MARK: Private properties

    private let networkService: NetworkServiceProtocol

    // MARK: Initialization

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Internal methods

    func getProducts(completion: @escaping (Result<[Section], Error>) -> Void) {
        let target = Target(path: "/favoritesProducts", method: .get, setParametresFromEncodable: nil, role: Role.user)

        networkService.sendRequest(target: target, responseType: [Section].self, completion: completion)
    }

    func getSearchProducts(productSearchRequest: ProductSearchRequest, completion: @escaping (Result<[Product], Error>) -> Void) {
        let target = Target(path: "/search", method: .post, setParametresFromEncodable: productSearchRequest, role: Role.user)
        networkService.sendRequest(target: target, responseType: [Product].self, completion: completion)
    }

    func getRecomendationsSearch(completion: @escaping (Result<[Product], Error>) -> Void) {
        let target = Target(path: "/search/recomendationsSearch", method: .get, setParametresFromEncodable: nil, role: Role.user)
        networkService.sendRequest(target: target, responseType: [Product].self, completion: completion)
    }
}
