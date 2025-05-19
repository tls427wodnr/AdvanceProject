//
//  Untitled.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

protocol RecentBooksUseCase {
    func fetch() -> [RecentBook]
    func save(book: Book)
    func deleteAll()
}

final class DefaultRecentBooksUseCase: RecentBooksUseCase {
    private let repository: RecentBooksRepository

    init(repository: RecentBooksRepository) {
        self.repository = repository
    }

    func fetch() -> [RecentBook] {
        repository.fetchRecentBooks()
    }

    func save(book: Book) {
        repository.saveToRecent(book: book)
    }

    func deleteAll() {
        repository.deleteAllRecentBooks()
    }
}
