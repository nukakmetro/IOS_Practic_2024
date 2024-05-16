//
//  Target.swift
//  FoodZ
//
//  Created by surexnx on 17.04.2024.
//

import Foundation
import Alamofire

enum Role {
    case user
    case admin
    case guest
}

enum HTTPHeaderFields: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"

    static var dictionary: [String: String] {
        return [
            HTTPHeaderFields.contentType.rawValue: "application/json",
            HTTPHeaderFields.acceptType.rawValue: "*/*",
            HTTPHeaderFields.acceptEncoding.rawValue: "gzip, deflate, br"
        ]
    }
}

class Target {
    /// The target's base `URL`.
    var baseURL: URL
    /// The path to be appended to `baseURL` to form the full `URL`.
    /// The HTTP method used in the request.
    var method: HTTPMethod
    /// The headers to be used in the request.
    var headers: HTTPHeaders?

    var parameters: AnyEncodable?
    var parametersImage: [String: Any]?
    var encoder: ParameterEncoder

    var role: Role

    init(path: String, method: HTTPMethod, setParametresFromEncodable parameters: Encodable?, role: Role, encoder: ParameterEncoder = JSONParameterEncoder.default) {
        if let url = URL(string: "http://localhost:8080/demo" + path) {
            self.baseURL = url
        } else {
            fatalError("Invalid base URL: \(path)")
        }
        self.method = method
        self.headers = HTTPHeaders(HTTPHeaderFields.dictionary)
        self.role = role
        self.encoder = encoder
        guard let parameters = parameters else { return }
        self.parameters = AnyEncodable(parameters)
    }

    init(path: String, method: HTTPMethod, setParametresFromMuiltipart parameters: [String: Int]?, role: Role, encoder: ParameterEncoder = JSONParameterEncoder.default) {
        if let url = URL(string: "http://localhost:8080/demo" + path) {
            self.baseURL = url
        } else {
            fatalError("Invalid base URL: \(path)")
        }
        self.method = method
        self.headers = HTTPHeaders(HTTPHeaderFields.dictionary)
        self.role = role
        self.encoder = encoder
        guard let parameters = parameters else { return }
        self.parametersImage = parameters

    }

    init(path: String, method: HTTPMethod, setParametresFromDictionary parameters: [String: String]?, role: Role) {
        if let url = URL(string: "http://localhost:8080/demo" + path) {
            self.baseURL = url
        } else {
            fatalError("Invalid base URL: \(path)")
        }
        self.method = method
        self.headers = HTTPHeaders(HTTPHeaderFields.dictionary)
        self.parameters = AnyEncodable(parameters)
        self.role = role
        encoder = JSONParameterEncoder.default
    }

    func addAuthHeader(access: String) {
        if role != Role.guest {
            headers?.update(name: "Authorization", value: "Bearer " + access)
        }
    }
}
