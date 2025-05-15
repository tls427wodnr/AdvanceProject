//
//  LocalBookRepository.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import Foundation
import CoreData
import RxSwift

// MARK: - Enum

enum CoreDataError: Error {
    case managerDeallocated
}

// MARK: - LocalBookRepository

final class LocalBookRepository: LocalBookRepositoryProtocol {

    // MARK: - Properties
    
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Initializer
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: "Model")) {
        self.persistentContainer = container
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data stack init failed: \(error)")
            }
        }
    }
    
    // MARK: - Methods

    func save(_ item: BookItem) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isbn == %@", item.isbn)

            do {
                let existing = try context.fetch(fetchRequest)
                if !existing.isEmpty {
                    completable(.completed)
                    return Disposables.create()
                }

                let book = Entity(context: context)
                book.isbn = item.isbn
                book.title = item.title
                book.image = item.image
                book.author = item.author
                book.publisher = item.publisher
                book.bookDescription = item.description

                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    func fetchAll() -> Single<[BookItem]> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let request: NSFetchRequest<Entity> = Entity.fetchRequest()

            do {
                let result = try context.fetch(request)
                let items = result.compactMap { entity -> BookItem? in
                    guard let isbn = entity.isbn,
                          let title = entity.title,
                          let image = entity.image,
                          let author = entity.author,
                          let publisher = entity.publisher,
                          let description = entity.bookDescription else {
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

    func delete(isbn: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let request: NSFetchRequest<Entity> = Entity.fetchRequest()
            request.predicate = NSPredicate(format: "isbn == %@", isbn)

            do {
                let books = try context.fetch(request)
                books.forEach { self.context.delete($0) }

                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    func deleteAll() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else {
                completable(.error(CoreDataError.managerDeallocated))
                return Disposables.create()
            }

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Entity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}
