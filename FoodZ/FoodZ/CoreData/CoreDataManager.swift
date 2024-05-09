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

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProductCoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
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

    func createNewProduct() -> ProductCreator {
        let product = ProductCreator(productId: UUID())
        return product
    }

    func saveProduct(product: ProductCreator) {
        var productEntity = ProductEntity(context: viewContext)
        productEntity.productName = product.productName
        productEntity.productCategory = product.productCategory
        productEntity.productPrice = product.productPrice
        productEntity.productCompound = product.productCompound
        productEntity.productId = product.productId
        productEntity.productWaitingTime = product.productWaitingTime
        productEntity.images = createImages(images: product.images)
        saveContext()
    }

    func createImages(images: Set<UUID>) -> Set<ProductImage> {
        var productImages = Set<ProductImage>()
        images.forEach { id in
            let productImage = ProductImage(context: viewContext)
            productImage.id = id
            productImages.insert(productImage)
        }
        return productImages
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
