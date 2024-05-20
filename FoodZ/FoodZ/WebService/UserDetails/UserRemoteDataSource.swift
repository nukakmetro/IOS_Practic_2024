//
//  UserRemoteDataSource.swift
//  FoodZ
//
//  Created by surexnx on 18.04.2024.
//

import Foundation
import Alamofire

final class UserRemoteDataSource {

    // MARK: Private properties

    private let tokenManager: TokenManager
    private let networkService: NetworkServiceProtocol

    // MARK: Initialization

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.tokenManager = TokenManager()
    }

    // MARK: Internal methods

    func userAuthorization(_ userRequst: UserRequest, completion: @escaping (Result<Void, Error>) -> Void) {
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

    func userRegistration(
        _ userRegistrationRequest: UserRegistrationRequest,
        completion: @escaping (Result<UserRegistrationResponse, Error>
        ) -> Void) {
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
            path: "/user/secured/userInfo",
            method: .get,
            setParametresFromEncodable: nil,
            role: Role.user
        )
        networkService.sendRequest(target: target, responseType: UserInfoModel.self, completion: completion)
    }

    func getInfoPickUpPoint(id: Int, completion: @escaping (Result<InfoPickUpPointResponce, Error>) -> Void) {
        let target = Target(path: "/pickUpPoint/get", method: .get, setParametresFromEncodable: IdRequest(id: id), role: .user, encoder: URLEncodedFormParameterEncoder.default)
        networkService.sendRequest(target: target, responseType: InfoPickUpPointResponce.self, completion: completion)
    }

    func selectPickUpPoint(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let target = Target(path: "/user/pickUpPoint/select", method: .post, setParametresFromEncodable: IdRequest(id: id), role: .user)
        networkService.sendRequest(target: target, responseType: Bool.self, completion: completion)
    }

    func userExit() -> Bool {
        var isExit = true
        let target = Target(path: "/user/secured/exit", method: .post, setParametresFromEncodable: tokenManager.getRefreshToken(), role: .user)
        networkService.sendRequest(target: target, responseType: Bool.self) { result in
            switch result {
            case .success:
                isExit = true
            case .failure:
                isExit = true
            }
        }
        return isExit
    }
}
