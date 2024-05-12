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
        let target = Target(path: "/product/favorites", method: .get, setParametresFromEncodable: nil, role: Role.user)

        networkService.sendRequest(target: target, responseType: [Section].self, completion: completion)
    }

    func getSearchProducts(productSearchRequest: ProductSearchRequest, completion: @escaping (Result<[Product], Error>) -> Void) {
        let target = Target(path: "/product/search", method: .post, setParametresFromEncodable: productSearchRequest, role: Role.user)
        networkService.sendRequest(target: target, responseType: [Product].self, completion: completion)
    }

    func getRecomendationsSearch(completion: @escaping (Result<[Product], Error>) -> Void) {
        let target = Target(path: "/product/search/recomendations", method: .get, setParametresFromEncodable: nil, role: Role.user)
        networkService.sendRequest(target: target, responseType: [Product].self, completion: completion)
    }

    func sendProduct(product: ProductRequest, images: [Data], completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/product/set", method: .post, setParametresFromEncodable: product, role: .user)

        networkService.sendRequest(target: target, responseType: ProductResponce.self) { [weak self] responce in
            guard let self = self else { return }
            switch responce {
            case .success(let value):
                images.forEach { image in
                    self.sendImages(image: image, value: value) { result in
                    }
                }
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    func toggleLike(productId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/product/like", method: .post, setParametresFromEncodable: productId, role: .user)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }

    func getSavedProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let target = Target(path: "/user/product/saved", method: .get, setParametresFromMuiltipart: nil, role: .user)
        networkService.sendRequest(target: target, responseType: [Product].self, completion: completion)
    }

    private func sendImages(image: Data, value: ProductResponce, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/product/image/set", method: .post, setParametresFromMuiltipart: ["id": value.id], role: .user)
        networkService.upload(target: target, image: image, responseType: Bool.self, completion: completion)
    }
}
