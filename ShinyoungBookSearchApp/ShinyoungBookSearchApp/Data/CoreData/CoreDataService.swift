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
    
    func save(book: Book) -> Single<Void> {
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
    
    func fetchSavedBooks() -> Single<[Book]> {
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
}
