//
//  ProductImage+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 07.05.2024.
//
//

import Foundation
import CoreData

@objc(ProductImage)
public class ProductImage: NSManagedObject {}

extension ProductImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductImage> {
        return NSFetchRequest<ProductImage>(entityName: "ProductImage")
    }

    @NSManaged public var id: UUID
    @NSManaged public var product: ProductEntity?

}

extension ProductImage: Identifiable {

}
