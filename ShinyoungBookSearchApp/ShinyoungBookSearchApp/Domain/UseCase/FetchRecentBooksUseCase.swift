//
//  FetchRecentBooksUseCase.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/19/25.
//

import RxSwift

protocol FetchRecentBooksUseCase {
    func execute() -> Single<[Book]>
}

final class DefaultFetchRecentBooksUseCase: FetchRecentBooksUseCase {
    private let repository: BookRepository

    init(repository: BookRepository) {
        self.repository = repository
    }

    func execute() -> Single<[Book]> {
        return repository.fetchRecentBooks()
    }
}
