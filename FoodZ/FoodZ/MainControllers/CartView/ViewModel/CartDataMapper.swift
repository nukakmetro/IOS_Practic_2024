//
//  CartDataMapper.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

final class CartDataMapper {
    func displayData(data: CartResponce) -> [CartSectionType] {
        var cartSection: [CartSectionType] = []
        var cartItems: [CartCellType] = []
        for cartItem in data.cartItems {
            cartItems.append(.bodyICell(mapTo(it: cartItem)))
        }
        cartSection.append(.bodySection(cartItems))
        return cartSection
    }

    func mapTo(it: CartProductResponce) -> CartProduct {
        return CartProduct(
            productId: it.productId,
            cartItemId: it.cartItemId,
            productPrice: String(it.productPrice),
            productImageId: it.productImageId,
            productName: it.productName,
            productCategory: it.productCategory,
            productCompound: it.productCompound,
            productDescription: it.productDescription,
            productSavedStatus: it.productSavedStatus,
            quantity: String(it.quantity)
        )
    }
}
