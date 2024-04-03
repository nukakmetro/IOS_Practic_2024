//
//  NetworkSetting.swift
//  Foodp2p
//
//  Created by surexnx on 07.03.2024.
//

import Foundation
import Alamofire

class NetworkInterceptor: Interceptor {

    var tokenManager = TokenManager.shared

    override func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let headers = urlRequest.allHTTPHeaderFields, let reqName = headers[HTTPHeaderFields.requestName.rawValue] else {
            completion(.success(urlRequest))
            return
            }

        if reqName == RequestNames.registrateUser.rawValue && reqName == RequestNames.authenticateUser.rawValue {
            // completion(.success(adaptedRequest))
        } else {
            completion(.success(urlRequest))
        }

    }

//    override func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            if request.retryCount < 2 {
//                print("retry the failed request with new token")
//                let token = tokenManager.getRefreshToken()
//                request.lastRequest?.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderFields.authentication.rawValue)
//                completion(.retry)
//            }
//        }
//    }

}

