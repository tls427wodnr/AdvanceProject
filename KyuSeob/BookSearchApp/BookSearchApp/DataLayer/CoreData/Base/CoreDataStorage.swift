//
//  CoreDataStorage.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation
import CoreData

protocol CoreDataStorageProtocol {
    var viewContext: NSManagedObjectContext { get }
    func saveContext(_ context: NSManagedObjectContext) throws
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
    func batchDelete(_ request: NSBatchDeleteRequest, in context: NSManagedObjectContext) throws
    func delete(_ object: NSManagedObject, in context: NSManagedObjectContext) throws
}

final class CoreDataStorage: CoreDataStorageProtocol {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookSearchApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext (_ context: NSManagedObjectContext) throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.saveError(error)
            }
        }
    }

    func fetch <T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        do {
            return try viewContext.fetch(request)
        } catch {
            throw CoreDataError.fetchError(error)
        }
    }

    func batchDelete(_ request: NSBatchDeleteRequest, in context: NSManagedObjectContext) throws {
        do {
            try context.execute(request)
        } catch {
            throw CoreDataError.deleteError(error)
        }
    }

    func delete(_ object: NSManagedObject, in context: NSManagedObjectContext) throws {
        context.delete(object)
    }

}
