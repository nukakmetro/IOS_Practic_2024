//
//  AnyEncodable.swift
//  FoodZ
//
//  Created by surexnx on 18.04.2024.
//

import Foundation

struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        self.encode = { encoder in
            try value.encode(to: encoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}
