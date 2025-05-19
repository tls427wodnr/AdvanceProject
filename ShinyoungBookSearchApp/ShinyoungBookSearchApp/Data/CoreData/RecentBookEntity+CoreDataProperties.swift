//
//  RecentBookEntity+CoreDataProperties.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//
//

import Foundation
import CoreData


extension RecentBookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentBookEntity> {
        return NSFetchRequest<RecentBookEntity>(entityName: "RecentBookEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var salePrice: String?
    @NSManaged public var contents: String?
    @NSManaged public var authors: String?
    @NSManaged public var viewedDate: Date?
    @NSManaged public var isbn: String?

}

extension RecentBookEntity : Identifiable {}

extension RecentBookEntity {
    func toDomain() -> Book {
        Book(
            title: self.title ?? "",
            authors: self.authors ?? "",
            salePrice: self.salePrice ?? "",
            thumbnailURL: self.thumbnailURL ?? "",
            contents: self.contents,
            isbn: self.isbn ?? ""
        )
    }
}

