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

final class UserRepository {

    // MARK: Private properties

    private var statefulNetworkService: StatefulNetworkService
    private let remoteDataSource: UserRemoteDataSource

    // MARK: Internal properties


    // MARK: Initialization

    init() {
        statefulNetworkService = StatefulNetworkService()
        self.remoteDataSource = UserRemoteDataSource(networkService: StatefulNetworkService())
    }
}

// MARK: UserRegistrationProtocol protocol

extension UserRepository: UserRegistrationProtocol {
    func userRegistration(userRegistrationRequest: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, Error>) -> Void) {
        remoteDataSource.userRegistration(userRegistrationRequest, completion: completion)
    }
}

// MARK: UserAuthorizationProtocol protocol

extension UserRepository: UserAuthorizationProtocol {
    func userAuthorization(userRequest: UserRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.userAuthorization(userRequest, completion: completion)
    }
}

extension UserRepository: ProfileUserProtocol {
    func fetchUserInfo(completion: @escaping (Result<UserInfoModel, Error>) -> Void) {
        remoteDataSource.getUserInfo(completion: completion)
    }
}
