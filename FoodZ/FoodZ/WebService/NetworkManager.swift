//
//  NetworkManager.swift
//  Foodp2p
//
//  Created by surexnx on 08.03.2024.
//

import Foundation
import Alamofire

class NetworkManager: NetworkManagerProtocol {
    func getHomeViewSections() -> [Section]? {
        return nil
    }

    var tokenManager = TokenManager.shared

    func registration(credentials: [String: String]) -> String? {

        let interceptor = NetworkInterceptor(retriers: [RetryPolicy(retryLimit: 2)])
        let response = AF.request(APIRouter.registrateUser(credentials),interceptor: interceptor).response

        guard let statusCode = response?.statusCode else { return "error"}

        return getError(statusCode: statusCode)
    }

    func authenticate(credentials: [String: String]) -> String? {
        var statusCode: Int = 0
        let interceptor = NetworkInterceptor(retriers: [RetryPolicy(retryLimit: 2)])
        let response = AF.request(APIRouter.authenticateUser(credentials),interceptor: interceptor).validate().responseDecodable(of: TokenManager.self) { response in

            do {
                self.tokenManager.updateToken(tokenManager: try response.result.get())
                guard let status = response.response?.statusCode else { return }
                statusCode = status
            } catch {
                print(error)
            }
        }
        return getError(statusCode: statusCode)
    }

    func getError(statusCode: Int) -> String? {
        switch statusCode {
        case 200:
            return nil
        case 400:
            return "неправильные данные"
        case 409:
            return "существует"
        case 402...500:
            return "повторите запрос"
        default:
            return "error"
        }
    }
}

