//
//  CartBookEntity.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation
import CoreData

@objc(CartBookEntity) // TODO: - troubleshooting
public class CartBookEntity: NSManagedObject {
//    public override var description: String {
//        return "BookSearchApp.CartBookEntity"
//    } // TODO: - troubleshooting
    @NSManaged public var createdAt: Date
    @NSManaged public var book: BookEntity
}

extension CartBookEntity {
    func configure(book: BookEntity) {
        self.createdAt = Date()
        self.book = book
    }
}

