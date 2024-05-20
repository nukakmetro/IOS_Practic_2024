//
//  PickUpDataSource.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import Alamofire

final class PickUpPointDataSource {

    // MARK: Private properties

    private let networkService: NetworkServiceProtocol

    // MARK: Initialization

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Internal methods

    func getAllPickUpPoint(completion: @escaping (Result<[PickUpPointResponce], Error>) -> Void) {
        let target = Target(path: "/pickUpPoint/all", method: .get, setParametresFromEncodable: nil, role: .user)
        networkService.sendRequest(target: target, responseType: [PickUpPointResponce].self, completion: completion)
    }

    func getPickUpPoint(id: Int, completion: @escaping (Result<PickUpPointResponce, Error>) -> Void) {
        let target = Target(path: "/pickUpPoint/get", method: .get, setParametresFromEncodable: IdRequest(id: id), role: .user, encoder: URLEncodedFormParameterEncoder.default)
        networkService.sendRequest(target: target, responseType: PickUpPointResponce.self, completion: completion)
    }

    func productSelf(id: Int, completion: @escaping (Result<ProductSelf, Error>) -> Void) {
        let target = Target(path: "/user/product", method: .get, setParametresFromEncodable: IdRequest(id: id), role: .user, encoder: URLEncodedFormParameterEncoder.default)
        networkService.sendRequest(target: target, responseType: ProductSelf.self, completion: completion)
    }

}
