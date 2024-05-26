//
//  FetchOrderProtocols.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

protocol OrderPastProtocol {
    func fetchPastOrders(completion: @escaping ((Result<[OrderResponce], Error>) -> Void))
}

protocol OrderCurrentProtocol {
    func fetchCurrentOrders(completion: @escaping ((Result<[OrderResponce], Error>) -> Void))
}

protocol OrderSelfProtocol {
    func getOrder(orderId: Int, completion: @escaping ((Result<OrderResponce, Error>) -> Void))
    func orderStatusReady(id: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func orderStatusCompleted(id: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}
