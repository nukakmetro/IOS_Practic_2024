//
//  PickUpPoint.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import MapKit

final class PickUpPointAnnotation: NSObject, MKAnnotation {
    var id: Int
    var coordinate: CLLocationCoordinate2D
    var name: String
    var title: String? {
        return name
    }
    var address: String

    init(coordinate: CLLocationCoordinate2D, name: String, id: Int, address: String) {
        self.coordinate = coordinate
        self.name = name
        self.id = id
        self.address = address
    }
}
