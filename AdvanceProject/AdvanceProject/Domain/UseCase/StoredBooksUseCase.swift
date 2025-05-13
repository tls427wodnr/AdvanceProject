//
//  DefaultStoredBooksUseCase.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation

protocol StoredBooksUseCase {
    func fetch() -> [Book]
    func remove(book: Book)
    func clear()
}

final class DefaultStoredBooksUseCase: StoredBooksUseCase {
    private let repository: StoredBooksRepository

    init(repository: StoredBooksRepository) {
        self.repository = repository
    }

    func fetch() -> [Book] {
        repository.fetchStoredBooks()
    }

    func remove(book: Book) {
        repository.delete(book: book)
    }

    func clear() {
        repository.deleteAll()
    }
}
