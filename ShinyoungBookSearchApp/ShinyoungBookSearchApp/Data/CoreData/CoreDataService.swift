//
//  CoreDataService.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/11/25.
//

import Foundation
import CoreData
import UIKit
import RxSwift

enum CoreDataError: Error {
    case entityNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
}

final class CoreDataService {
    static let shared = CoreDataService()
    
    var context: NSManagedObjectContext {
        guard let context = (
            UIApplication.shared.delegate as? AppDelegate
        )?.persistentContainer.viewContext else {
            fatalError("AppDelegate 오류")
        }
        
        return context
    }
    
    private init() {}
    
    func saveFavorite(book: Book) -> Single<Void> {
        return Single.create { observer in
            let newBook = BookEntity(context: self.context)
            newBook.title = book.title
            newBook.authors = book.authors
            newBook.thumbnailURL = book.thumbnailURL
            newBook.salePrice = book.salePrice
            newBook.contents = book.contents
            
            do {
                try self.context.save()
                observer(.success(()))
            } catch {
                observer(.failure(CoreDataError.saveFailed(error)))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchFavoriteBooks() -> Single<[Book]> {
        return Single.create { observer in
            let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            
            do {
                let entities = try self.context.fetch(request)
                let books = entities.map { $0.toDomain() }
                observer(.success(books))
            } catch {
                observer(.failure(CoreDataError.fetchFailed(error)))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAllBooks() -> Single<Void> {
        return Single.create { observer in
            let request: NSFetchRequest<NSFetchRequestResult> = BookEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try self.context.execute(deleteRequest)
                try self.context.save()
                observer(.success(()))
            } catch {
                observer(.failure(CoreDataError.deleteFailed(error)))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteBook(isbn: String) -> Single<Void> {
        return Single.create { observer in
            let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isbn == %@", isbn)
            
            do {
                let result = try self.context.fetch(request)
                
                for data in result as [NSManagedObject] {
                    self.context.delete(data)
                }
                
                try self.context.save()
                observer(.success(()))
            } catch {
                observer(.failure(CoreDataError.deleteFailed(error)))
            }
            
            return Disposables.create()
        }
    }
    
    func saveRecent(book: Book) -> Single<Void> {
        return Single.create { observer in
            let request: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "isbn == %@", book.isbn)
            
            do {
                let existing = try self.context.fetch(request)
                existing.forEach { self.context.delete($0) }
                
                let newBook = RecentBookEntity(context: self.context)
                newBook.title = book.title
                newBook.authors = book.authors
                newBook.thumbnailURL = book.thumbnailURL
                newBook.salePrice = book.salePrice
                newBook.contents = book.contents
                newBook.viewedDate = Date()
                newBook.isbn = book.isbn
                
                try self.context.save()
                observer(.success(()))
            } catch {
                observer(.failure(CoreDataError.saveFailed(error)))
            }
            
            return Disposables.create()
        }
    }
    
    func fetchRecentBooks() -> Single<[Book]> {
        return Single.create { observer in
            let request: NSFetchRequest<RecentBookEntity> = RecentBookEntity.fetchRequest()
            
            let sort = NSSortDescriptor(key: "viewedDate", ascending: false)
            request.sortDescriptors = [sort]
            
            do {
                let entities = try self.context.fetch(request)
                let books = entities.map { $0.toDomain() }
                observer(.success(books))
            } catch {
                observer(.failure(CoreDataError.fetchFailed(error)))
            }
            
            return Disposables.create()
        }
    }
}
