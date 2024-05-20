//
//  AuthorizationRemoteRepository.swift
//  FoodZ
//
//  Created by surexnx on 18.04.2024.
//

import Foundation

protocol UserRegistrationProtocol {
    func userRegistration(userRegistrationRequest: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, Error>) -> Void)
}

protocol UserAuthorizationProtocol {
    func userAuthorization(userRequest: UserRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol ProfileUserProtocol {
    func fetchUserInfo(completion: @escaping (Result<UserInfoModel, Error>) -> Void)
}

protocol UserExitProtocol {
    func fetchUserExit() -> Bool
}

protocol UserPickUpPointProtocol {
    func selectPickUpPoint(id: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    func getInfoPickUpPoint(id: Int, completion: @escaping (Result<InfoPickUpPointResponce, Error>) -> Void)

}
final class UserRepository {

    // MARK: Private properties

    private let remoteDataSource: UserRemoteDataSource

    // MARK: Initialization

    init() {
        self.remoteDataSource = UserRemoteDataSource(networkService: StatefulNetworkService())
    }
}

// MARK: UserRegistrationProtocol

extension UserRepository: UserRegistrationProtocol {
    func userRegistration(userRegistrationRequest: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, Error>) -> Void) {
        remoteDataSource.userRegistration(userRegistrationRequest, completion: completion)
    }
}

// MARK: UserAuthorizationProtocol

extension UserRepository: UserAuthorizationProtocol {
    func userAuthorization(userRequest: UserRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.userAuthorization(userRequest, completion: completion)
    }
}

// MARK: ProfileUserProtocol

extension UserRepository: ProfileUserProtocol {
    func fetchUserInfo(completion: @escaping (Result<UserInfoModel, Error>) -> Void) {
        remoteDataSource.getUserInfo(completion: completion)
    }
}

// MARK: UserExitProtocol

extension UserRepository: UserExitProtocol {
    func fetchUserExit() -> Bool {
        return remoteDataSource.userExit()
    }
}

extension UserRepository: UserPickUpPointProtocol {
    func selectPickUpPoint(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        remoteDataSource.selectPickUpPoint(id: id, completion: completion)
    }

    func getInfoPickUpPoint(id: Int, completion: @escaping (Result<InfoPickUpPointResponce, Error>) -> Void) {
        remoteDataSource.getInfoPickUpPoint(id: id, completion: completion)
    }
}
