//
//  CartRepository.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation
import CoreData

protocol CartRepositoryProtocol {
    func addToCart(isbn: String, title: String, author: String, price: Int)
    func fetchCartItems() -> [(isbn: String, title: String, author: String, price: Int)]
    func removeAllCartItems()
    func removeCartItem(isbn: String)
    func isItemInCart(isbn: String) -> Bool
}

final class CartRepository: CartRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addToCart(isbn: String, title: String, author: String, price: Int) {
        let cartItem = CartItemEntity(context: context)
        cartItem.isbn = isbn
        cartItem.title = title
        cartItem.author = author
        cartItem.price = Double(price)
        
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data changes: \(error)")
        }
    }
    
    func fetchCartItems() -> [(isbn: String, title: String, author: String, price: Int)] {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            return cartItems.map { item in
                return (isbn: item.isbn ?? "",
                        title: item.title ?? "",
                        author: item.author ?? "",
                        price: Int(item.price))
            }
        } catch {
            print("Failed to fetch Core Data items: \(error)")
            return []
        }
    }
    
    func removeAllCartItems() {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            cartItems.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Failed to remove Core Data items: \(error)")
        }
    }
    
    func removeCartItem(isbn: String) {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            cartItems.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Failed to remove Core Data items: \(error)")
        }
    }
    
    func isItemInCart(isbn: String) -> Bool {
        let fetchRequest: NSFetchRequest<CartItemEntity> = CartItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let cartItems = try context.fetch(fetchRequest)
            return cartItems.count > 0
        } catch {
            print("Failed to fetch Core Data item count: \(error)")
            return false
        }
    }
}
