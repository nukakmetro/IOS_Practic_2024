//
//  APIRouter.swift
//  Foodp2p
//
//  Created by surexnx on 08.03.2024.
//

import Foundation
import Alamofire

enum HTTPHeaderFields: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case requestName     = "RequestName"
}

enum ContentType: String {
    case json = "application/json"
}

enum RequestNames: String {
    case authenticateUser
    case registrateUser
}

public enum APIRouter: URLRequestConvertible {

    static let baseURL = "BaseURL"

    case authenticateUser([String: Any])
    case registrateUser([String: Any])

    var method: HTTPMethod {
        switch self {
        case .authenticateUser:
            return .post
        case .registrateUser:
            return .post
        }
    }

    var path: String {
        switch self {
        case .authenticateUser:
            return "/authenticateUser"
        case .registrateUser:
            return "/registrateUser"
        }
    }

    var authheader: String {

        switch self {
        case .authenticateUser:
            return ""
        case .registrateUser:
            return ""
        }
    }

    var requestName: String {
        switch self {
        case .authenticateUser:
            return RequestNames.authenticateUser.rawValue
        case .registrateUser:
            return RequestNames.registrateUser.rawValue
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .registrateUser:
            return URLEncoding.default
        case .authenticateUser:
            return URLEncoding.default
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let param: [String: Any]? = {
            switch self {
            case .authenticateUser(let credentials):
                return credentials
            case .registrateUser(let credentials):
                return credentials
            }
        }()

        let url = try APIRouter.baseURL.asURL()
        let finalPath = path
        var request = URLRequest(url: url.appendingPathComponent(finalPath))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)

        // Get the header data
        request.addValue(getAuthorizationHeader(), forHTTPHeaderField: HTTPHeaderFields.authentication.rawValue)
        request.addValue(getRequestNameHeader(), forHTTPHeaderField: HTTPHeaderFields.requestName.rawValue)

        return try encoding.encode(request, with: param)
    }

    private func getAuthorizationHeader() -> String {
        let header = authheader
        return header
    }

    private func getRequestNameHeader() -> String {
        let header = requestName
        return header
    }
}
