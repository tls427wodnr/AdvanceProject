//
//  CoreDataManager.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import Foundation
import CoreData
import RxSwift

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack init failed: \(error)")
            }
        }
    }

    // MARK: - Create

    func saveBook(_ item: BookItem) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isbn == %@", item.isbn)

            do {
                let existing = try self.context.fetch(fetchRequest)
                if !existing.isEmpty {
                    completable(.completed)
                    return Disposables.create()
                }

                let book = Entity(context: self.context)
                book.isbn = item.isbn
                book.title = item.title
                book.image = item.image
                book.author = item.author
                book.publisher = item.publisher
                book.bookDescription = item.description

                try self.context.save()
                completable(.completed)

            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    // MARK: - Read

    func fetchBooks() -> Single<[BookItem]> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let request: NSFetchRequest<Entity> = Entity.fetchRequest()

            do {
                let result = try self.context.fetch(request)
                let items: [BookItem] = result.compactMap { book in
                    guard let isbn = book.isbn,
                          let title = book.title,
                          let image = book.image,
                          let author = book.author,
                          let publisher = book.publisher,
                          let description = book.bookDescription else {
                        return nil
                    }

                    return BookItem(
                        isbn: isbn,
                        title: title,
                        image: image,
                        author: author,
                        publisher: publisher,
                        description: description
                    )
                }
                single(.success(items))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    // MARK: - Delete by ISBN

    func deleteBook(byISBN isbn: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let request: NSFetchRequest<Entity> = Entity.fetchRequest()
            request.predicate = NSPredicate(format: "isbn == %@", isbn)

            do {
                let books = try self.context.fetch(request)
                books.forEach { self.context.delete($0) }

                try self.context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
    
    // MARK: - Delete All
    
    func deleteBooks() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Entity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try self.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: self.context)
                try self.context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}

// MARK: - CoreData Error

enum CoreDataError: Error {
    case managerDeallocated
}
