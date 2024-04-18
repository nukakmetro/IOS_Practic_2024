//
//  AuthorizationRemoteRepository.swift
//  FoodZ
//
//  Created by surexnx on 18.04.2024.
//

import Foundation

protocol UserRegistrationProtocol {
    func userRegistration(userRegistrationRequest: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, Error>) -> ())
}

protocol UserAuthorizationProtocol {
    func userAuthorization(userRequest: UserRequest, completion: @escaping (Result<Void, Error>) -> ())
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
    func userRegistration(userRegistrationRequest: UserRegistrationRequest, completion: @escaping (Result<UserRegistrationResponse, Error>) -> ()) {
        remoteDataSource.userRegistration(userRegistrationRequest, completion: completion)
    }
}

// MARK: UserAuthorizationProtocol protocol

extension UserRepository: UserAuthorizationProtocol {
    func userAuthorization(userRequest: UserRequest, completion: @escaping (Result<Void, Error>) -> ()) {
        remoteDataSource.userAuthorization(userRequest, completion: completion)
    }
}
