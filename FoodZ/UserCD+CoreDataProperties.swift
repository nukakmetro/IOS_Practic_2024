//
//  UserCD+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//
//

import Foundation
import CoreData

extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var userFirstName: String?
    @NSManaged public var userId: Int64
    @NSManaged public var username: String?
    @NSManaged public var userSecondName: String?

}

extension UserCD : Identifiable {
}
