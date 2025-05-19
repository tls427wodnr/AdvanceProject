//
//  CoreDataManager.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData 로딩 실패: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData 저장 완료")
            } catch {
                print("CoreData 저장 실패: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Save (중복 저장 방지 포함)
    func save(book: Book) {
        
        if isBookAlreadyStored(book) {
            print("이미 저장된 책입니다: \(book.title)")
            return
        }

        let stored = StoredBooks(context: context)
        stored.title = book.title
        stored.thumbnail = book.thumbnail
        stored.authors = book.authors.joined(separator: ", ")
        stored.contents = book.contents
        stored.publisher = book.publisher
        stored.url = book.url
        stored.price = Int64(book.price)
        stored.isbn = book.isbn
        print("Save 저장 완료")
        saveContext()
    }

    // MARK: - 중복 확인 (ISBN 기준)
    func isBookAlreadyStored(_ book: Book) -> Bool {
        let fetchRequest: NSFetchRequest<StoredBooks> = StoredBooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", book.isbn)
        let result = try? context.fetch(fetchRequest)
        return result?.isEmpty == false
    }

    // MARK: - 모든 책 불러오기
    func fetchStoredBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<StoredBooks> = StoredBooks.fetchRequest()
        do {
            let stored = try context.fetch(fetchRequest)
            return stored.map { $0.toBook() }
        } catch {
            print("Fetch 실패: \(error)")
            return []
        }
    }

    // MARK: - 특정 책 삭제 (ISBN 기준)
    func delete(book: Book) {
        let fetchRequest: NSFetchRequest<StoredBooks> = StoredBooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", book.isbn)

        do {
            let result = try context.fetch(fetchRequest)
            for target in result {
                context.delete(target)
            }
            saveContext()
        } catch {
            print("삭제 실패: \(error)")
        }
    }

    // MARK: - 전체 삭제
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = StoredBooks.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            saveContext()
        } catch {
            print("전체 삭제 실패: \(error)")
        }
    }
    
    // MARK: - 최근 본 책 저장
    func saveToRecent(book: Book) {
        let fetchRequest: NSFetchRequest<RecentBooks> = RecentBooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", book.isbn)

        if let existing = try? context.fetch(fetchRequest), let old = existing.first {
            context.delete(old)
        }

        let stored = RecentBooks(context: context)
        stored.title = book.title
        stored.thumbnail = book.thumbnail
        stored.authors = book.authors.joined(separator: ", ")
        stored.contents = book.contents
        stored.publisher = book.publisher
        stored.url = book.url
        stored.price = Int64(book.price)
        stored.isbn = book.isbn
        stored.createdAt = Date()
        print("saveToRecent 저장 완료")
        saveContext()
    }

    // MARK: - 최근 본 책 불러오기
    func fetchRecentBooks(limit: Int = 10) -> [RecentBook] {
        let fetchRequest: NSFetchRequest<RecentBooks> = RecentBooks.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchLimit = limit

        do {
            let result = try context.fetch(fetchRequest)
            return result.map { $0.toRecentBook() }
        } catch {
            print("최근 책 불러오기 실패: \(error)")
            return []
        }
    }
    
    // MARK: - 최근 본 책 전체 삭제
    func deleteAllRecentBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecentBooks.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            saveContext()
            print("최근 본 책 전체 삭제 완료")
        } catch {
            print("최근 본 책 전체 삭제 실패: \(error)")
        }
    }
}
