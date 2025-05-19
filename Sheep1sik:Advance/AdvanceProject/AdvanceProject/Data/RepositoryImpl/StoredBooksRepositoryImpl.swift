//
//  StoredBooksRepositoryImpl.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation

final class StoredBooksRepositoryImpl: StoredBooksRepository {
    func fetchStoredBooks() -> [Book] {
        CoreDataManager.shared.fetchStoredBooks()
    }

    func delete(book: Book) {
        CoreDataManager.shared.delete(book: book)
    }

    func deleteAll() {
        CoreDataManager.shared.deleteAllBooks()
    }
}
