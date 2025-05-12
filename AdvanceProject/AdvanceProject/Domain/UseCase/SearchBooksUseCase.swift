//
//  SearchBooksUseCase.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//
import RxSwift

protocol SearchBooksUseCase {
    func execute(query: String) -> Single<[Book]>
}

final class DefaultSearchBooksUseCase: SearchBooksUseCase {
    private let repository: BookRepository

    init(repository: BookRepository) {
        self.repository = repository
    }

    func execute(query: String) -> Single<[Book]> {
        return repository.searchBooks(query: query)
    }
}
