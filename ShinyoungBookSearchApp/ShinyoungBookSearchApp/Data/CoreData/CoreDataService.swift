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
    case serviceDeallocated
    case entityNotFound
    case saveFailed(Error)
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
                forEntityName: "BookEntity",
                in: self.context
            ) else {
                observer(.failure(CoreDataError.entityNotFound))
                return Disposables.create()
            }
            
            let newBook = NSManagedObject(entity: entity, insertInto: self.context)
            
            newBook.setValue(book.title, forKey: "title")
            newBook.setValue(book.authors, forKey: "authors")
            newBook.setValue(book.thumbnailURL, forKey: "thumbnailURL")
            newBook.setValue(book.salePrice, forKey: "salePrice")
            newBook.setValue(book.contents, forKey: "contents")
            
            do {
                try self.context.save()
                observer(.success(()))
            } catch {
                observer(.failure(CoreDataError.saveFailed(error)))
            }
            
            return Disposables.create()
        }
    }
}
