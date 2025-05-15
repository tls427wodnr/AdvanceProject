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
    let bookRepository: BookRepositoryProtocol
    let cartRepository: CartRepositoryProtocol
    let historyRepository: HistoryRepositoryProtocol
    
    init(context: NSManagedObjectContext) {
        bookRepository = BookRepository()
        cartRepository = CartRepository(context: context)
        historyRepository = HistoryRepository(context: context)
    }
    
    func makeTabBarController() -> UITabBarController {
        let bookUseCase = BookUseCase(bookRepository: bookRepository)
        let cartItemUseCase = CartItemUseCase(cartRepository: cartRepository)
        let historyUseCase = HistoryUseCase(historyRepository: historyRepository)
        
        return TabBarController(bookUseCase: bookUseCase, cartItemUseCase: cartItemUseCase, historyUseCase: historyUseCase)
    }
}
