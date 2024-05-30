//
//  OrderRemoteDataSource.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation
import Alamofire

final class OrderRemoteDataSource {

    // MARK: Private properties

    private let networkService: NetworkServiceProtocol

    // MARK: Initialization

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchPastOrders(completion: @escaping (Result<[OrderResponce], Error>) -> Void) {
        let targer = Target(path: "/user/order/past", method: .get, setParametresFromEncodable: nil, role: .user)
        networkService.sendRequest(target: targer, responseType: [OrderResponce].self, completion: completion)
    }

    func fetchCurrentOrders(completion: @escaping (Result<[OrderResponce], Error>) -> Void) {
        let targer = Target(path: "/user/order/current", method: .get, setParametresFromEncodable: nil, role: .user)
        networkService.sendRequest(target: targer, responseType: [OrderResponce].self, completion: completion)
    }

    func fetchOrder(id: Int, completion: @escaping (Result<OrderResponce, Error>) -> Void) {
        let target = Target(path: "/user/order", method: .get, setParametresFromEncodable: IdRequest(id: id), role: .user, encoder: URLEncodedFormParameterEncoder.default)
        networkService.sendRequest(target: target, responseType: OrderResponce.self, completion: completion)
    }

    func orderStatusReady(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/order/ready", method: .get, setParametresFromEncodable: IdRequest(id: id), role: .user, encoder: URLEncodedFormParameterEncoder.default)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }

    func orderStatusCompleted(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/order/completed", method: .get, setParametresFromEncodable: IdRequest(id: id), role: .user, encoder: URLEncodedFormParameterEncoder.default)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }
}
