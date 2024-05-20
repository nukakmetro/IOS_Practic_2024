//
//  MapViewDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import MapKit

final class MapViewDataMapper {
    func displayData(data: [PickUpPointResponce]) -> [PickUpPointAnnotation] {
        var pickUpPoint: [PickUpPointAnnotation] = []
        for datum in data {
            let annotation = PickUpPointAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: datum.latitude, longitude: datum.longitude),
                name: datum.pickUpPointName,
                id: datum.pickUpPointId,
                address: datum.city + ", " + datum.house + ", " + datum.house
            )
            pickUpPoint.append(annotation)
        }
        return pickUpPoint
    }
}
