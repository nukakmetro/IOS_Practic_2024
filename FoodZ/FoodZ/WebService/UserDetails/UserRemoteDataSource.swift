//
//  UserRemoteDataSource.swift
//  FoodZ
//
//  Created by surexnx on 18.04.2024.
//

import Foundation

final class UserRemoteDataSource {
    private let tokenManager: TokenManager
    let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.tokenManager = TokenManager.shared
    }

    func userAuthorization(_ userRequst: UserRequest,completion: @escaping (Result<Void, Error>) -> Void) {
        let target = Target(
            path: "/auth", 
            method: .post,
            setParametresFromEncodable: userRequst,
            role: Role.guest
        )
        networkService.sendRequest(target: target, responseType: TokenEntity.self) { [weak self] result in
            switch result {
            case .success(let tokenEntity):
                self?.tokenManager.updateToken(tokenEntity: tokenEntity)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func userRegistration(_ userRegistrationRequest: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, Error>) -> Void) {
        let target = Target(
            path: "/registration",
            method: .post,
            setParametresFromEncodable: userRegistrationRequest,
            role: Role.guest
        )
        networkService.sendRequest(target: target, responseType: UserRegistrationResponse.self, completion: completion)
    }

    func getUserInfo(completion: @escaping (Result<UserInfoModel, Error>) -> Void) {
        let target = Target(
            path: "/userInfo",
            method: .get,
            setParametresFromEncodable: nil,
            role: Role.user
        )
        networkService.sendRequest(target: target, responseType: UserInfoModel.self, completion: completion)
    }
}
