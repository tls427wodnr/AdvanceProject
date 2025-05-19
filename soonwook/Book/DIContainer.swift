//
//  DIContainer.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation
import CoreData
import UIKit
import DataLayer
import DomainLayer
import PresentationLayer

struct DIContainer {
    let searchBookRepository: SearchBookRepositoryProtocol
    let cartRepository: CartItemRepositoryProtocol
    let recentBookRepository: RecentBookRepositoryProtocol
    
    init(context: NSManagedObjectContext) {
        searchBookRepository = SearchBookRepository()
        cartRepository = CartItemRepository(context: context)
        recentBookRepository = RecentBookRepository(context: context)
    }
    
    func makeTabBarController() -> UITabBarController {
        let searchBookUseCase = SearchBookUseCase(bookRepository: searchBookRepository)
        let cartItemUseCase = CartItemUseCase(cartRepository: cartRepository)
        let recentBookUseCase = RecentBookUseCase(recentBookRepository: recentBookRepository)
        
        return TabBarController(searchBookUseCase: searchBookUseCase, cartItemUseCase: cartItemUseCase, recentBookUseCase: recentBookUseCase)
    }
}
