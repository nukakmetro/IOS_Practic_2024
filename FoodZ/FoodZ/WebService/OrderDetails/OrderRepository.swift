//
//  OrderRepository.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

final class OrderRepository {

    // MARK: Private properties

    private let remoteDataSource: OrderRemoteDataSource

    init() {
        self.remoteDataSource = OrderRemoteDataSource(networkService: StatefulNetworkService())
    }
}
// MARK: UserRegistrationProtocol protocol

extension OrderRepository: OrderPastProtocol {
    func fetchPastOrders(completion: @escaping ((Result<[OrderResponce], Error>) -> Void)) {
        remoteDataSource.fetchPastOrders(completion: completion)
    }
}

// MARK: UserRegistrationProtocol protocol

extension OrderRepository: FullOrderProtocol {
    func fetchFullOrder(orderId: Int, completion: @escaping ((Result<[FullOrderResponce], Error>) -> Void)) {
        remoteDataSource.fetchFullOrder(orderId: orderId, completion: completion)
    }
}

// MARK: UserRegistrationProtocol protocol

extension OrderRepository: OrderCurrentProtocol {
    func fetchCurrentOrders(completion: @escaping ((Result<[OrderResponce], Error>) -> Void)) {
        remoteDataSource.fetchCurrentOrders(completion: completion)
    }
}
