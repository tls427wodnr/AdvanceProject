//
//  BookEntity.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation
import CoreData

@objc(BookEntity)
public class BookEntity: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var authors: [String]?
    @NSManaged public var thumbnail: String?
    @NSManaged public var price: Int64
    @NSManaged public var contents: String?
}

extension BookEntity {
    func configure(from book: Book) {
        self.title = book.title
        self.authors = book.authors
        self.thumbnail = book.thumbnail
        self.price = Int64(book.price)
        self.contents = book.contents
    }
}
