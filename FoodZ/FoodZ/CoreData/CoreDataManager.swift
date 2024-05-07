//
//  CoreDataManager.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {

    static let shared = CoreDataManager()

    private init() {}

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProductCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func createNewProduct() -> ProductEntity {
        let product = ProductEntity(context: viewContext)
        product.productId = UUID()
        return product
    }

    func createProduct(
        productCategory: String?,
        productCompound: String?,
        productDescription: String?,
        productWaitingTime: String?,
        productName: String?,
        productPrice: String?
    ) -> ProductEntity {

        let product = ProductEntity(context: viewContext)
        product.productId = UUID()
        product.productCategory = productCategory
        product.productCompound = productCompound
        product.productDescription = productDescription
        product.productWaitingTime = productWaitingTime
        product.productPrice = productPrice
        product.productName = productName
        saveContext()
        return product
    }

    func fetchProducts() -> [ProductEntity] {
        let productFetch = ProductEntity.fetchRequest()
        let result = try? viewContext.fetch(productFetch)
        return result ?? []
    }

    func fetchById(id: UUID) -> ProductEntity? {
        let productFetch = ProductEntity.fetchRequest()
        if let result = try? viewContext.fetch(productFetch).first(where: { $0.productId == id }) {
            return result
        }
        return nil
    }

    func deleteByid(id: UUID) {
        let productFetch = ProductEntity.fetchRequest()
        if let result = try? viewContext.fetch(productFetch).first(where: { $0.productId == id }) {
            viewContext.delete(result)
            saveContext()
        }
    }

    func createImage() -> ProductImage {
        let image = ProductImage(context: viewContext)
        image.id = UUID()
        return image
    }

    func deleteImage(id: UUID) {
        let imageFetch = ProductImage.fetchRequest()
        if let result = try? viewContext.fetch(imageFetch).first(where: { $0.id == id }) {
            viewContext.delete(result)
            saveContext()
        }
    }
}
