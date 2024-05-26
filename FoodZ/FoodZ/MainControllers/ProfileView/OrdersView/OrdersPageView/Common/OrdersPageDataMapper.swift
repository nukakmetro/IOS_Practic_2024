//
//  OrdersPageDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

final class OrdersPageDataMapper {
    func dispayData(from dataModel: [OrderResponce]) -> [OrderSectionType] {
        var sections: [OrderSectionType] = []
        for data in dataModel {
            let orderHeader = OrderBodyHeader(
                id: UUID(),
                orderId: "Заказ # " + String(data.id),
                totalPrice: "Цена: " + String(data.totalPrice),
                status: data.status,
                whose: data.whose
            )
            sections.append(.bodyHeaderSection(UUID(), .bodyHeaderCell(orderHeader)))
            var bodyCells: [OrderCellType] = []
            for orderItem in data.orderItems {
                let orderBody = OrderBody(
                    id: UUID(),
                    productId: orderItem.productId,
                    price: String(orderItem.price),
                    quantity: String(orderItem.quantity),
                    productName: orderItem.productName,
                    productCategory: orderItem.productCategory
                )
                bodyCells.append(.bodyCell(orderBody))
            }
            sections.append(.bodySection(UUID(), bodyCells))
        }
        return sections
    }
}
