//
//  AppDIContainer.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/19/25.
//

import Foundation

final class AppDIContainer {
    func makeBookSearchViewModel() -> BookSearchViewModel {
        let repository = BookRepositoryImpl()
        let searchUseCase = DefaultBookSearchUseCase(repository: repository)
        let recentUseCase = DefaultFetchRecentBooksUseCase(repository: repository)
        return BookSearchViewModel(bookSearchUseCase: searchUseCase, fetchRecentBooksUseCase: recentUseCase)
    }

    func makeSavedBooksViewModel() -> SavedBooksViewModel {
        let repository = BookRepositoryImpl()
        let useCase = DefaultSavedBooksUseCase(repository: repository)
        return SavedBooksViewModel(savedBooksUseCase: useCase)
    }

    func makeBookDetailViewModel(book: Book) -> BookDetailViewModel {
        let repository = BookRepositoryImpl()
        let useCase = DefaultSaveBookUseCase(repository: repository)
        return BookDetailViewModel(book: book, saveBookUseCase: useCase)
    }
}
