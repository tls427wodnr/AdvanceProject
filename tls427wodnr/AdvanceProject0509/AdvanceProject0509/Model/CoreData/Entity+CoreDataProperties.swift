//
//  Entity+CoreDataProperties.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var isbn: String?
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var author: String?
    @NSManaged public var publisher: String?
    @NSManaged public var bookDescription: String?

}

extension Entity : Identifiable {

}
