//
//  RecentBookRepository.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation
import CoreData
import DomainLayer

public final class RecentBookRepository: RecentBookRepositoryProtocol {
    private let context: NSManagedObjectContext
    private let maxCount = 10 // 최대 저장 갯수
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func saveBook(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String) {
        let book = BookEntity(context: context)
        book.isbn = isbn
        book.title = title
        book.authors = authors
        book.price = Double(price)
        book.contents = contents
        book.thumbnail = thumbnail
        book.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data changes: \(error)")
        }
    }
    
    public func fetchBook() -> [(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String, timestamp: Date)] {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let books = try context.fetch(fetchRequest)
            return books.map { history in
                return (isbn: history.isbn ?? "",
                        title: history.title ?? "",
                        authors: history.authors ?? [],
                        price: Int(history.price),
                        contents: history.contents ?? "",
                        thumbnail: history.thumbnail ?? "",
                        timestamp: history.timestamp ?? Date())
            }
        } catch {
            print("Failed to fetch Core Data books: \(error)")
            return []
        }
    }
    
    public func deleteBookIfNeeded() {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let books = try context.fetch(fetchRequest)
            
            guard books.count >= maxCount else { return } // 총 저장 갯수가 10개 미만이면 삭제 필요없으므로 리턴
            
            let booksToDelete = books.dropFirst(maxCount - 1) // 최근 9개 제외 나머지(삭제 대상) 추출
            booksToDelete.forEach { context.delete($0) }
            
            try context.save()
        } catch {
            print("Failed to delete Core Data books: \(error)")
        }
    }
    
    public func isBookExist(isbn: String) -> Bool {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let books = try context.fetch(fetchRequest)
            return books.count > 0
        } catch {
            print("Failed to fetch Core Data recentBook count: \(error)")
            return false
        }
    }
    
    public func updateBook(isbn: String) {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let books = try context.fetch(fetchRequest)
            guard !books.isEmpty else { return }
            
            // 이미 저장되어 있으므로 날짜만 최신으로 업데이트
            books.forEach { $0.timestamp = Date() }
            try context.save()
        } catch {
            print("Failed to fetch or save Core Data recentBook: \(error)")
        }
    }
}
