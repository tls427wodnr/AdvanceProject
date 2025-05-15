//
//  BookEntity+CoreDataProperties.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/11/25.
//
//

import Foundation
import CoreData


extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var authors: String?
    @NSManaged public var salePrice: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var contents: String?

}

extension BookEntity : Identifiable {}

extension BookEntity {
    func toDomain() -> Book {
        Book(
            title: self.title ?? "",
            authors: self.authors ?? "",
            salePrice: self.salePrice ?? "",
            thumbnailURL: self.thumbnailURL ?? "",
            contents: self.contents
        )
    }
}
