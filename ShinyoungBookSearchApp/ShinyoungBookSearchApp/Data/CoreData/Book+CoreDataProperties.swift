//
//  Book+CoreDataProperties.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/11/25.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var authors: String?
    @NSManaged public var salePrice: String?
    @NSManaged public var thumbnailURL: String?
    @NSManaged public var contents: String?

}

extension Book : Identifiable {

}
