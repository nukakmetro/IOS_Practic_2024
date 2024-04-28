//
//  OrdersPageDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

final class OrdersPageDataMapper {
    func dispayData(from dataModel: [OrderResponce]) -> [OrdersViewCellType] {
        return dataModel.map { orderResponce in
            return mapTo(data: orderResponce)
        }
    }

    private func mapTo(data: OrderResponce) -> OrdersViewCellType {
        let orderEntity = OrderEntity(
            orderId: String(data.orderId),
            orderPrice: String(data.orderPrice),
            orderTime: dateFormater(data.orderTime),
            orderType: data.orderType
        )
        return OrdersViewCellType.orderCell(orderEntity)
    }

    private func dateFormater(_ date: String) -> String {
        if let spaceIndex = date.firstIndex(of: " ") {
            let dateSubstring = date.prefix(upTo: spaceIndex)
            let array = dateSubstring.components(separatedBy: "-")
            if array.count == 3 {
                return array[2] + "." + array[1] + "." + array[0]
            }
        }
        return "01.01.2001 "
    }
}
