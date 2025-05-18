//
//  BookRepository.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/18/25.
//

import RxSwift

protocol BookRepository {
    func fetchRecentBooks() -> Single<[Book]>
    func searchBooks(query: String, page: Int) -> Single<BookSearchResponse>
    func saveFavorite(book: Book) -> Single<Void>
    func saveRecent(book: Book) -> Single<Void>
    func fetchFavoriteBooks() -> Single<[Book]>
    func deleteAllBooks() -> Single<Void>
    func deleteBook(isbn: String) -> Single<Void>
}
