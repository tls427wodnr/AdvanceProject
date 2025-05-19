//
//  RecentBookEntity.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/14/25.
//

import Foundation
import CoreData

@objc(RecentBookEntity)
public class RecentBookEntity: NSManagedObject {
    @NSManaged public var lastViewedAt: Date
    @NSManaged public var book: BookEntity
}

extension RecentBookEntity {
    func configure(book: BookEntity) {
        self.lastViewedAt = Date()
        self.book = book
    }

    func toDomain() -> RecentBook {
        return RecentBook(
            book: self.book.toDomain(),
            lastViewedAt: self.lastViewedAt
        )
    }
}
