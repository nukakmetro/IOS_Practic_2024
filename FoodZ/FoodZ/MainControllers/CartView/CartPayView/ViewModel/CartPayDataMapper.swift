//
//  CartPayDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 22.05.2024.
//

import Foundation

final class CartPayDataMapper {
    func displayData(data: CartCreateOrderResponce) -> [CartPaySectionType] {
        var sections: [CartPaySectionType] = []
        for cart in data.infoAddressCarts {
            sections.append(.bodyHeaderSection(id: UUID(), .bodyHeaderCell(CartPayHeader(address: cart.address))))
            var items: [CartPayCellType] = []
            for item in cart.cartItems {
                items.append(.bodyCell(CartPayBody(id: UUID(), price: String(item.productPrice), name: item.productName, quantity: String(item.quantity))))
            }
            sections.append(.bodySection(id: UUID(), items) )
        }
        sections.append(.footerSection(id: UUID(), .footerCell(CartPayFooter(totalPrice: String(data.totalPrice)))))
        return sections
    }
}
