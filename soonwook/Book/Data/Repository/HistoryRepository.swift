//
//  HistoryRepository.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation
import CoreData

protocol HistoryRepositoryProtocol {
    func recordHistory(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String)
    func fetchHistories() -> [(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String, timestamp: Date)]
    func deleteHistory()
    func isHistoryExist(isbn: String) -> Bool
    func updateHistory(isbn: String)
}

final class HistoryRepository: HistoryRepositoryProtocol {
    private let context: NSManagedObjectContext
    private let recordLimit = 10 // 최대 저장 갯수
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func recordHistory(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String) {
        let history = HistoryEntity(context: context)
        history.isbn = isbn
        history.title = title
        history.authors = authors
        history.price = Double(price)
        history.contents = contents
        history.thumbnail = thumbnail
        history.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data changes: \(error)")
        }
    }
    
    func fetchHistories() -> [(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String, timestamp: Date)] {
        let fetchRequest: NSFetchRequest<HistoryEntity> = HistoryEntity.fetchRequest()
        
        do {
            let histories = try context.fetch(fetchRequest)
            return histories.map { history in
                return (isbn: history.isbn ?? "",
                        title: history.title ?? "",
                        authors: history.authors ?? [],
                        price: Int(history.price),
                        contents: history.contents ?? "",
                        thumbnail: history.thumbnail ?? "",
                        timestamp: history.timestamp ?? Date())
            }
        } catch {
            print("Failed to fetch Core Data histories: \(error)")
            return []
        }
    }
    
    func deleteHistory() {
        let fetchRequest: NSFetchRequest<HistoryEntity> = HistoryEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let histories = try context.fetch(fetchRequest)
            
            guard histories.count >= recordLimit else { return } // 총 저장 갯수가 10개 미만이면 삭제 필요없으므로 리턴
            
            let historiesToDelete = histories.dropFirst(recordLimit - 1) // 최근 9개 제외 나머지(삭제 대상) 추출
            historiesToDelete.forEach { context.delete($0) }
            
            try context.save()
        } catch {
            print("Failed to delete Core Data histories: \(error)")
        }
    }
    
    func isHistoryExist(isbn: String) -> Bool {
        let fetchRequest: NSFetchRequest<HistoryEntity> = HistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let histories = try context.fetch(fetchRequest)
            return histories.count > 0
        } catch {
            print("Failed to fetch Core Data history count: \(error)")
            return false
        }
    }
    
    func updateHistory(isbn: String) {
        let fetchRequest: NSFetchRequest<HistoryEntity> = HistoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let histories = try context.fetch(fetchRequest)
            guard !histories.isEmpty else { return }
            
            // 이미 저장되어 있으므로 날짜만 최신으로 업데이트
            histories.forEach { $0.timestamp = Date() }
            try context.save()
        } catch {
            print("Failed to fetch or save Core Data history: \(error)")
        }
    }
}
