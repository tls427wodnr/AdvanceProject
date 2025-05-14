//
//  CartItemUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation

protocol CartItemUseCaseProtocol {
    func fetchCartItems() -> [CartItem]
    func removeCartItem(_ cartItem: CartItem)
    func removeAllCartItems()
    func isItemInCart(isbn: String) -> Bool
    func addToCart(isbn: String, title: String, author: String, price: Int)
}

final class CartItemUseCase: CartItemUseCaseProtocol {
    private let cartRepository: CartRepositoryProtocol
    
    init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
    }
    
    func fetchCartItems() -> [CartItem] {
        let items = cartRepository.fetchCartItems().map { item in
            return CartItem(isbn: item.isbn, title: item.title, author: item.author, price: item.price)
        }
        return items
    }
    
    func removeCartItem(_ cartItem: CartItem) {
        cartRepository.removeCartItem(isbn: cartItem.isbn)
    }
    
    func removeAllCartItems() {
        cartRepository.removeAllCartItems()
    }
    
    func isItemInCart(isbn: String) -> Bool {
        cartRepository.isItemInCart(isbn: isbn)
    }
    
    func addToCart(isbn: String, title: String, author: String, price: Int) {
        cartRepository.addToCart(isbn: isbn, title: title, author: author, price: price)
    }
}
