//
//  ProductEntity+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 07.05.2024.
//
//

import Foundation
import CoreData

@objc(ProductEntity)
public class ProductEntity: NSManagedObject {}

extension ProductEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var productCategory: String?
    @NSManaged public var productCompound: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productId: UUID
    @NSManaged public var productName: String?
    @NSManaged public var productPrice: String?
    @NSManaged public var productWaitingTime: String?
    @NSManaged public var images: Set<ProductImage>

}

// MARK: Generated accessors for images
extension ProductEntity {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ProductImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ProductImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension ProductEntity: Identifiable {

}

extension ProductEntity {
    func mapToRequest() -> ProductRequest {
        ProductRequest(
            productName: productName,
            productPrice: Int(productPrice ?? "1"),
            productWaitingTime: Int(productWaitingTime ?? "1"),
            productCategory: productCategory,
            productCompound: productCompound,
            productDescription: productDescription
        )
    }
}
