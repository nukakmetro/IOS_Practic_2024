//
//  TestNetworkManager.swift
//  FoodZ
//
//  Created by surexnx on 17.04.2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func sendRequest<Response: Decodable>(target: Target, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void)
}

final class StatefulNetworkService: NetworkServiceProtocol {

    private var tokenManager = TokenManager.shared

    func sendRequest<Response: Decodable>(target: Target, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void) {
        target.addAuthHeader(access: tokenManager.getAccessToken())
        print(target.headers)
        AF.request(target.baseURL, method: target.method, parameters: target.parameters, encoder: JSONParameterEncoder.default, headers: target.headers).validate(statusCode: 200..<299).responseDecodable(of: responseType) { [weak self] result in
            guard let self else { return }
            print(result.response?.statusCode)
            guard result.response?.statusCode != 401 else {
                refreshToken { result in

                    switch result {
                    case .success:
                        self.sendRequest(target: target, responseType: responseType, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                return
            }
            switch result.result {
            case .success(let responce):
                completion(.success(responce))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        AF.request("http://localhost:8080/demo/updateToken", method: .post, parameters: tokenManager.getRefreshToken(), encoder: JSONParameterEncoder.default, headers: HTTPHeaders(HTTPHeaderFields.dictionary)).validate(statusCode: 200..<300).responseDecodable(of: TokenEntity.self) { [weak self] responce in
            switch responce.result {
            case .success(let tokenEntity):
                print("token updated")
                self?.tokenManager.updateToken(tokenEntity: tokenEntity)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}