//
//  OrderRemoteDataSource.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

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
    func fetchFullOrder(orderId: Int, completion: @escaping (Result<[FullOrderResponce], Error>) -> Void) {
        let targer = Target(path: "/user/order/getOrder", method: .get, setParametresFromEncodable: orderId, role: .user)
        networkService.sendRequest(target: targer, responseType: [FullOrderResponce].self, completion: completion)
    }
}
