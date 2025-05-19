//
//  RecentBooksUseCase.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/15/25.
//

import Foundation

protocol RecentBooksUseCaseProtocol: AnyObject {
    func addRecentBook(book: Book) throws
    func fetchRecentBooks() throws -> [RecentBook]
}

final class RecentBooksUseCase: RecentBooksUseCaseProtocol {
    private let recentBookRepository: RecentBookRepositoryProtocol

    init(recentBookRepository: RecentBookRepositoryProtocol) {
        self.recentBookRepository = recentBookRepository
    }

    func addRecentBook(book: Book) throws {
        try recentBookRepository.addAndFetchRecentBookList(book: book)
    }

    func fetchRecentBooks() throws -> [RecentBook] {
        try recentBookRepository.fetchSortedRecentBooks()
    }
}
