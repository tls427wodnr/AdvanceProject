//
//  FetchBooksUseCase.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

// MARK: - FetchBooksUseCase

final class FetchBooksUseCase: FetchBooksUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: BookRepositoryProtocol
    
    // MARK: - Initializer
    
    init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func execute(query: String, start: Int) -> Observable<[BookItem]> {
        return repository.fetchBooks(query: query, start: start)
    }
}
