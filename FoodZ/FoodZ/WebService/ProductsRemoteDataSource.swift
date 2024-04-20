//
//  File.swift
//  FoodZ
//
//  Created by surexnx on 17.04.2024.
//

import Foundation
final class ProductsRemoteDataSource {
    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getProducts(completion: @escaping (Result<[Section], Error>) -> ()) {
        let target = Target(path: "/favoritesProducts", method: .get, setParametresFromEncodable: nil, role: Role.user)

        networkService.sendRequest(target: target, responseType: [Section].self, completion: completion)
    }

    func getSearchProducts(searchString: SearchEntity, completion: @escaping (Result<[Section], Error>) -> ()) {
        let target = Target(path: "/searchProducts", method: .get, setParametresFromEncodable: searchString, role: Role.user)
        networkService.sendRequest(target: target, responseType: [Section].self, completion: completion)
    }
}
