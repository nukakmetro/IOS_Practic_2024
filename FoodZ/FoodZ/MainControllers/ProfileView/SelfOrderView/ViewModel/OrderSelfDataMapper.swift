//
//  SelfOrderDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import Foundation

final class OrderSelfDataMapper {
    func dispayData(from dataModel: OrderResponce) -> [OrderSelfSectionType] {
        var sections: [OrderSelfSectionType] = []
            let orderHeader = OrderSelfHeader(
                id: UUID(),
                orderId: "Заказ # " + String(dataModel.id),
                totalPrice: "Цена: " + String(dataModel.totalPrice),
                status: dataModel.status,
                whose: dataModel.whose
            )
            sections.append(.headerSection(UUID(), .headerCell(orderHeader)))

            var bodyCells: [OrderSelfCellType] = []
            for orderItem in dataModel.orderItems {
                let orderBody = OrderSelfBody(
                    id: UUID(),
                    productId: orderItem.productId,
                    price: String(orderItem.price),
                    quantity: String(orderItem.quantity),
                    productName: orderItem.productName,
                    productCategory: orderItem.productCategory,
                    imageId: orderItem.imageId
                )
                bodyCells.append(.bodyCell(orderBody))
            }
            sections.append(.bodySection(UUID(), bodyCells))

        return sections
    }
}
