//
//  HomeLocalRepository.swift
//  FoodZ
//
//  Created by surexnx on 31.03.2024.
//

import Foundation
import CoreData

final class HomeLocalRepository: SectionsLocalRepository {

    // MARK: Internal properties

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: Internal methods

    func saveContext() {
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

    func obtainSavedData() -> [SectionCD] {
        let userFetchRequest = SectionCD.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "sectionId", ascending: true)
        userFetchRequest.sortDescriptors = [sortDescriptor]
        let result = try? viewContext.fetch(userFetchRequest)
        return result ?? []
    }

    func createSections(with sections: [Section]?) {

    }

    func createProducts(with products: [Product]?) -> Set<ProductCD> {
        var newProducts: Set<ProductCD> = []
        guard let products = products else { return newProducts }
        products.forEach { product in
            let newProduct = ProductCD(context: viewContext)
            newProduct.productId = Int64(product.productId)
            newProduct.productCompound = product.productCompound
            newProduct.productCategory = product.productCategory
            newProduct.productDescription = product.productDescription
            newProduct.productName = product.productName
            newProduct.productPrice = Int64(product.productPrice)
            newProduct.productRating = Int64(product.productRating)
            newProduct.productWaitingTime = Int64(product.productWaitingTime)
            newProduct.productUsername = product.productUsername
            newProduct.productImages = createImages(with: product.productImages)
            newProducts.insert(newProduct)
        }
        return newProducts
    }

    func createImages(with images: [Image]?) -> Set<ImageCD> {
        let newImages: Set<ImageCD> = []
        guard let images = images else { return newImages }
        images.forEach { image in
            let newImage = ImageCD(context: viewContext)
            newImage.imageId = Int64(image.imageId)
            newImage.imageName = image.imageName
            newImages.insert(newImage)
        }
        return newImages
    }
}
