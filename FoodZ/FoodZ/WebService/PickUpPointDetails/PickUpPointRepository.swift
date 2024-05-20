//
//  PickUpRepository.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

protocol PickUpPointProtocol {
    func getAllPickUpPoint(completion: @escaping (Result<[PickUpPointResponce], Error>) -> Void)
    func getPickUpPoint(id: Int, completion: @escaping (Result<PickUpPointResponce, Error>) -> Void)
}

final class PickUpPointRepository {

    // MARK: Private properties

    private let dataSource: PickUpPointDataSource

    // MARK: Initialization

    init() {
        let statefulNetworkService = StatefulNetworkService()
        self.dataSource = PickUpPointDataSource(networkService: statefulNetworkService)
    }
}

extension PickUpPointRepository: PickUpPointProtocol {
    func getAllPickUpPoint(completion: @escaping (Result<[PickUpPointResponce], Error>) -> Void) {
        dataSource.getAllPickUpPoint(completion: completion)
    }

    func getPickUpPoint(id: Int, completion: @escaping (Result<PickUpPointResponce, Error>) -> Void) {
        dataSource.getPickUpPoint(id: id, completion: completion)
    }
}
