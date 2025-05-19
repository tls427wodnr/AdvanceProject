//
//  BookSearchUseCase.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/18/25.
//

import RxSwift

protocol BookSearchUseCase {
    func execute(query: String, page: Int) -> Single<[Book]>
}

final class DefaultBookSearchUseCase: BookSearchUseCase {
    private let repository: BookRepository
    
    init(repository: BookRepository) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) -> Single<[Book]> {
        repository.searchBooks(query: query, page: page)
            .map { response in
                response.documents.map { $0.toDomain() }
            }
    }
}
