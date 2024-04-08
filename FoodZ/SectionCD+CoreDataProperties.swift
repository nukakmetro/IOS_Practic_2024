//
//  SectionCD+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//
//

import Foundation
import CoreData

extension SectionCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SectionCD> {
        return NSFetchRequest<SectionCD>(entityName: "SectionCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var items: Set<ProductCD>?

}

// MARK: Generated accessors for items
extension SectionCD {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ProductCD)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ProductCD)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension SectionCD : Identifiable {
}
