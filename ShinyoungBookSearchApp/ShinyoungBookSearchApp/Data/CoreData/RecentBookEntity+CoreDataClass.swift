//
//  RecentBookEntity+CoreDataClass.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//
//

import Foundation
import CoreData

@objc(RecentBookEntity)
public class RecentBookEntity: NSManagedObject {
    public static let className = "RecentBookEntity"
    public enum Key {
        static let title = "title"
        static let authors = "authors"
        static let salePrice = "salePrice"
        static let thumbnailURL = "thumbnailURL"
        static let contents = "contents"
        static let viewedDate = "viewedDate"
    }
}
