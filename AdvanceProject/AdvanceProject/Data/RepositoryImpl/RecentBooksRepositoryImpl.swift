//
//  RecentBooksRepositoryImpl.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

final class RecentBooksRepositoryImpl: RecentBooksRepository {
    func fetchRecentBooks() -> [RecentBook] {
        CoreDataManager.shared.fetchRecentBooks()
    }

    func saveToRecent(book: Book) {
        CoreDataManager.shared.saveToRecent(book: book)
    }

    func deleteAllRecentBooks() {
        CoreDataManager.shared.deleteAllRecentBooks()
    }
}
