//
//  ImageCD+CoreDataProperties.swift
//  FoodZ
//
//  Created by surexnx on 01.04.2024.
//
//

import Foundation
import CoreData

extension ImageCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCD> {
        return NSFetchRequest<ImageCD>(entityName: "ImageCD")
    }

    @NSManaged public var imageId: Int64
    @NSManaged public var imageName: String?
    @NSManaged public var productImage: ProductCD?

}

extension ImageCD: Identifiable {

}
