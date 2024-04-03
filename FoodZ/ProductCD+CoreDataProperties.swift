//
//  ProductCD+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//
//

import Foundation
import CoreData

extension ProductCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCD> {
        return NSFetchRequest<ProductCD>(entityName: "ProductCD")
    }

    @NSManaged public var productCategory: String?
    @NSManaged public var productCompound: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productId: Int64
    @NSManaged public var productName: String?
    @NSManaged public var productPrice: Int64
    @NSManaged public var productRating: Int64
    @NSManaged public var productUsername: String?
    @NSManaged public var productWaitingTime: Int64
    @NSManaged public var productImages: Set<ImageCD>?
    @NSManaged public var sectionsItems: SectionCD?

}

// MARK: Generated accessors for productImages
extension ProductCD {

    @objc(addProductImagesObject:)
    @NSManaged public func addToProductImages(_ value: ImageCD)

    @objc(removeProductImagesObject:)
    @NSManaged public func removeFromProductImages(_ value: ImageCD)

    @objc(addProductImages:)
    @NSManaged public func addToProductImages(_ values: NSSet)

    @objc(removeProductImages:)
    @NSManaged public func removeFromProductImages(_ values: NSSet)

}

extension ProductCD: Identifiable {

}
