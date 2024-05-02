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
    case userImage = "/user/getImage"
}

struct UserImageRequest: Encodable {
    let username: String
}

final class CustomImageView: UIImageView {

    func loadImage(withUsername username: UserImageRequest, path: ImageLoadPath) {
        let target = Target(
            path: path.rawValue,
            method: .get,
            setParametresFromEncodable: username,
            role: .guest
        )
        DispatchQueue.global().async {
            AF.request(target.baseURL, method: target.method, parameters: target.parameters).validate(statusCode: 200..<299).responseData { responce in
                switch responce.result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                case .failure(let error):
                    fatalError("error load image")
                }
            }
        }
    }

    func loadImage(withId id: Int, path: ImageLoadPath) {
        let target = Target(path: path.rawValue, method: .get, setParametresFromEncodable: id, role: .user)
        DispatchQueue.main.async {
            AF.request(target.baseURL, method: target.method, parameters: target.parameters).validate(statusCode: 200..<299).responseData { responce in
                switch responce.result {
                case .success(let data):
                    self.image = UIImage(data: data)
                case .failure(_):
                    fatalError("error load image")
                }
            }
        }
    }
}
