//
//  CartItemRepositoryProtocol.swift
//  Book
//
//  Created by 권순욱 on 5/15/25.
//

import Foundation

public protocol CartItemRepositoryProtocol {
    func addToCart(isbn: String, title: String, author: String, price: Int)
    func fetchCartItems() -> [(isbn: String, title: String, author: String, price: Int)]
    func removeAllCartItems()
    func removeCartItem(isbn: String)
    func isItemInCart(isbn: String) -> Bool
}
