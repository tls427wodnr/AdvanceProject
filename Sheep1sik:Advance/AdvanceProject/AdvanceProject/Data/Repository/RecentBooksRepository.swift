//
//  Untitled.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

protocol RecentBooksRepository {
    func fetchRecentBooks() -> [RecentBook]
    func saveToRecent(book: Book)
    func deleteAllRecentBooks()
}
