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

protocol FullOrderProtocol {
    func fetchFullOrder(orderId: Int, completion: @escaping ((Result<[FullOrderResponce], Error>) -> Void))
}
