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

    // MARK: Initialization

    init() {
        self.remoteDataSource = OrderRemoteDataSource(networkService: StatefulNetworkService())
    }
}

// MARK: OrderPastProtocol

extension OrderRepository: OrderPastProtocol {
    func fetchPastOrders(completion: @escaping ((Result<[OrderResponce], Error>) -> Void)) {
        remoteDataSource.fetchPastOrders(completion: completion)
    }
}

// MARK: OrderCurrentProtocol

extension OrderRepository: OrderCurrentProtocol {
    func fetchCurrentOrders(completion: @escaping ((Result<[OrderResponce], Error>) -> Void)) {
        remoteDataSource.fetchCurrentOrders(completion: completion)
    }
}

// MARK: OrderSelfProtocol

extension OrderRepository: OrderSelfProtocol {
    func orderStatusReady(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteDataSource.orderStatusReady(id: id, completion: completion)
    }
    
    func orderStatusCompleted(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteDataSource.orderStatusCompleted(id: id, completion: completion)
    }
    
    func getOrder(orderId: Int, completion: @escaping ((Result<OrderResponce, Error>) -> Void)) {
        remoteDataSource.fetchOrder(id: orderId, completion: completion)
    }
}
