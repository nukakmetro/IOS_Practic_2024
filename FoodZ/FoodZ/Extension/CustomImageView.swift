//
//  CustomImageView.swift
//  FoodZ
//
//  Created by surexnx on 29.04.2024.
//

import Foundation
import UIKit
import Alamofire

enum ImageLoadPath: String {
    case userImage = "/user/image/get"
    case productImage = "/image"
}

struct IdRequest: Encodable {
    let id: Int
}

final class CustomImageView: UIImageView {

    func loadImage(withId id: Int, path: ImageLoadPath) {
        let target = Target(
            path: path.rawValue,
            method: .get,
            setParametresFromEncodable: IdRequest(id: id),
            role: .guest
        )
        DispatchQueue.global().async {
            AF
                .request(target.baseURL, method: target.method, parameters: target.parameters)
                .validate(statusCode: 200..<299)
                .responseData { responce in
                switch responce.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.image = UIImage(named: "Cat")
                    }
                }
            }
        }
    }
}
