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
    
    private var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    var context: NSManagedObjectContext {
        guard let context = appDelegate?.persistentContainer.viewContext else {
            fatalError("AppDelegate 오류")
        }
        
        return context
    }
    
    private init() {}
    
    func saveFavorite(book: Book) -> Single<Void> {
        return Single.create { observer in
            guard let entity = NSEntityDescription.entity(
                forEntityName: BookEntity.className,
                in: self.context
            ) else {
                observer(.failure(CoreDataError.entityNotFound))
                return Disposables.create()
            }
            
            let newBook = NSManagedObject(entity: entity, insertInto: self.context)
            
            newBook.setValue(book.title, forKey: BookEntity.Key.title)
            newBook.setValue(book.authors, forKey: BookEntity.Key.authors)
            newBook.setValue(book.thumbnailURL, forKey: BookEntity.Key.thumbnailURL)
            newBook.setValue(book.salePrice, forKey: BookEntity.Key.salePrice)
            newBook.setValue(book.contents, forKey: BookEntity.Key.contents)
            
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
    
    func deleteBook(title: String) -> Single<Void> {
        return Single.create { observer in
            let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "title == %@", title)
            
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
            guard let entity = NSEntityDescription.entity(
                forEntityName: RecentBookEntity.className,
                in: self.context
            ) else {
                observer(.failure(CoreDataError.entityNotFound))
                return Disposables.create()
            }
            
            let newBook = NSManagedObject(entity: entity, insertInto: self.context)
            
            newBook.setValue(book.title, forKey: RecentBookEntity.Key.title)
            newBook.setValue(book.authors, forKey: RecentBookEntity.Key.authors)
            newBook.setValue(book.thumbnailURL, forKey: RecentBookEntity.Key.thumbnailURL)
            newBook.setValue(book.salePrice, forKey: RecentBookEntity.Key.salePrice)
            newBook.setValue(book.contents, forKey: RecentBookEntity.Key.contents)
            newBook.setValue(Date(), forKey: RecentBookEntity.Key.viewedDate)
            
            do {
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
            
            let sort = NSSortDescriptor(key: RecentBookEntity.Key.viewedDate, ascending: false)
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
