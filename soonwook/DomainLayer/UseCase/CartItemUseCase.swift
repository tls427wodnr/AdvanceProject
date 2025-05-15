//
//  CartItemUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation

public protocol CartItemUseCaseProtocol {
    func fetchCartItems() -> [CartItem]
    func removeCartItem(_ cartItem: CartItem)
    func removeAllCartItems()
    func isItemInCart(isbn: String) -> Bool
    func addToCart(isbn: String, title: String, author: String, price: Int)
}

public struct CartItemUseCase: CartItemUseCaseProtocol {
    private let cartRepository: CartRepositoryProtocol
    
    public init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }
    
    public func fetchCartItems() -> [CartItem] {
        let items = cartRepository.fetchCartItems().map { item in
            return CartItem(isbn: item.isbn, title: item.title, author: item.author, price: item.price)
        }
        return items
    }
    
    public func removeCartItem(_ cartItem: CartItem) {
        cartRepository.removeCartItem(isbn: cartItem.isbn)
    }
    
    public func removeAllCartItems() {
        cartRepository.removeAllCartItems()
    }
    
    public func isItemInCart(isbn: String) -> Bool {
        cartRepository.isItemInCart(isbn: isbn)
    }
    
    public func addToCart(isbn: String, title: String, author: String, price: Int) {
        cartRepository.addToCart(isbn: isbn, title: title, author: author, price: price)
    }
}
