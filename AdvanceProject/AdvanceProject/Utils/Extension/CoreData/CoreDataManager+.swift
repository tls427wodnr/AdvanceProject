//
//  CoreDataManager+.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import CoreData

extension CoreDataManager {

    // MARK: - Save (중복 저장 방지 포함)
    func save(book: Book) {
        if isBookAlreadyStored(book) {
            print("이미 저장된 책입니다: \(book.title)")
            return
        }

        let context = self.context
        let stored = StoredBooks(context: context)
        stored.title = book.title
        stored.thumbnail = book.thumbnail
        stored.authors = book.authors.joined(separator: ", ")
        stored.contents = book.contents
        stored.publisher = book.publisher
        stored.url = book.url
        stored.price = Int64(book.price)

        saveContext()
    }

    // MARK: - 중복 확인 (URL 기준)
    func isBookAlreadyStored(_ book: Book) -> Bool {
        let fetchRequest: NSFetchRequest<StoredBooks> = StoredBooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", book.url)
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

    // MARK: - 특정 책 삭제 (URL 기준)
    func delete(book: Book) {
        let fetchRequest: NSFetchRequest<StoredBooks> = StoredBooks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", book.url)
        if let result = try? context.fetch(fetchRequest), let target = result.first {
            context.delete(target)
            saveContext()
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
}
