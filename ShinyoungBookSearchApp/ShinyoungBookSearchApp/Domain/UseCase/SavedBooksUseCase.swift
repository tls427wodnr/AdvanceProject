//
//  SavedBooksUseCase.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/19/25.
//

import RxSwift

protocol SavedBooksUseCase {
    func fetchSavedBooks() -> Single<[Book]>
    func deleteAllBooks() -> Single<Void>
    func deleteBook(isbn: String) -> Single<Void>
}

final class DefaultSavedBooksUseCase: SavedBooksUseCase {
    private let repository: BookRepository
    
    init(repository: BookRepository) {
        self.repository = repository
    }
    
    func fetchSavedBooks() -> Single<[Book]> {
        return repository.fetchFavoriteBooks()
    }
    
    func deleteAllBooks() -> Single<Void> {
        return repository.deleteAllBooks()
    }
    
    func deleteBook(isbn: String) -> Single<Void> {
        return repository.deleteBook(isbn: isbn)
    }
}
