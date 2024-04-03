//
//  PickupPointCD+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//
//

import Foundation
import CoreData

extension PickupPointCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PickupPointCD> {
        return NSFetchRequest<PickupPointCD>(entityName: "PickupPointCD")
    }

    @NSManaged public var pickupPointCity: String?
    @NSManaged public var pickupPointHouse: Int64
    @NSManaged public var pickupPointSchedule: String?
    @NSManaged public var pickupPointStreet: String?
    @NSManaged public var pickupPontId: Int64

}

extension PickupPointCD: Identifiable {

}
