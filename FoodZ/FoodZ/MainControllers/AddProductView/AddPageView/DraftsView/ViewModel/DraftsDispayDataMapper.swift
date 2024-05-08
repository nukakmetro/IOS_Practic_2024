//
//  DraftsDispayDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation
import UIKit

final class DraftsDataMapper {

    private var fileManager: ImageFileManager?

    init() {
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            self.fileManager = ImageFileManager(documentsDirectory: directory)
        }
    }

    func dispayData(from dataModel: [ProductEntity]) -> [DraftsCellType] {
        return dataModel.map { orderResponce in
            return mapTo(data: orderResponce)
        }
    }

    private func mapTo(data: ProductEntity) -> DraftsCellType {
        var fetchImage: Data?

        if
            let fileManager = fileManager,
            let imageId = data.images.first?.id,
            let imageData = fileManager.fetchImage(id: imageId)
        {
            fetchImage = imageData
        }

        let product = DraftsProduct(
            id: data.productId,
            name: data.productName,
            price: data.productPrice,
            image: fetchImage,
            time: data.productWaitingTime)

        return DraftsCellType.product(product)
    }

}
