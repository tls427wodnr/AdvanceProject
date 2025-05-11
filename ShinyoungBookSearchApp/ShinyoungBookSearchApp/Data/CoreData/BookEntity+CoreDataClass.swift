//
//  BookEntity+CoreDataClass.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/11/25.
//
//

import Foundation
import CoreData

@objc(BookEntity)
public class BookEntity: NSManagedObject {
    public static let className = "BookEntity"
    public enum Key {
        static let title = "title"
        static let authors = "authors"
        static let salePrice = "salePrice"
        static let thumbnailURL = "thumbnailURL"
        static let contents = "contents"
    }
}
