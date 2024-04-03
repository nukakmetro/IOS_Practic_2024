//
//  LocalRepository.swift
//  FoodZ
//
//  Created by surexnx on 31.03.2024.
//

import Foundation
import CoreData

protocol LocalRepository {
    associatedtype T

    var viewContext: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
    func obtainSavedData() -> [T]
}

protocol SectionsLocalRepository: LocalRepository {
    func createSections(with sections: [Section]?)
    func createProducts(with products: [Product]?) -> Set<ProductCD>
    func createImages(with images: [Image]?) -> Set<ImageCD>
}
