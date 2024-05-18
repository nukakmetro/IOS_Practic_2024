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
    func upload<Response: Decodable>(target: Target, image: Data, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void)
}

final class StatefulNetworkService: NetworkServiceProtocol {

    private var tokenManager: TokenManager

    init(tokenManager: TokenManager = TokenManager()) {
        self.tokenManager = tokenManager
    }

    func upload<Response: Decodable>(target: Target, image: Data, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void) {
        target.addAuthHeader(access: tokenManager.getAccessToken())
        AF.upload(
            multipartFormData: { multipartFormData in
            if let parameters = target.parametersImage {
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: .utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }
                }
                multipartFormData.append(image, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        },
            to: target.baseURL,
            method: target.method,
            headers: target.headers
        )
        .validate(statusCode: 200..<299)
        .responseDecodable(of: responseType) { [weak self] result in
            guard let self else { return }

            guard result.response?.statusCode != 401 else {
                refreshToken { result in
                    switch result {
                    case .success:
                        self.upload(target: target, image: image, responseType: responseType, completion: completion)
                    case .failure(let error):
                        self.tokenManager.keysClear()
                        NotificationCenter.default.post(name: .sessionExpired, object: nil)
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

    func sendRequest<Response: Decodable>(target: Target, responseType: Response.Type, completion: @escaping (Result<Response, Error>) -> Void) {
        target.addAuthHeader(access: tokenManager.getAccessToken())

        AF.request(target.baseURL, method: target.method, parameters: target.parameters, encoder: target.encoder, headers: target.headers)
            .validate(statusCode: 200..<299)
            .responseDecodable(of: responseType) { [weak self] result in
            guard let self else { return }
            guard result.response?.statusCode != 401 else {
                refreshToken { result in
                    switch result {
                    case .success:
                        self.sendRequest(target: target, responseType: responseType, completion: completion)
                    case .failure(let error):
                        self.tokenManager.keysClear()
                        NotificationCenter.default.post(name: .sessionExpired, object: nil)
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
        AF.request(
            "http://localhost:8080/demo/updateToken",
            method: .post,
            parameters: tokenManager.getRefreshToken(),
            encoder: JSONParameterEncoder.default,
            headers: HTTPHeaders(HTTPHeaderFields.dictionary)
        )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: TokenEntity.self) { [weak self] responce in
            switch responce.result {
            case .success(let tokenEntity):
                print("token updated")
                self?.tokenManager.updateToken(tokenEntity: tokenEntity)
                completion(.success(()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
