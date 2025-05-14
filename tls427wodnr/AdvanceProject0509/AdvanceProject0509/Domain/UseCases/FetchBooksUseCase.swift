//
//  FetchBooksUseCase.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

final class FetchBooksUseCase: FetchBooksUseCaseProtocol {
    
    private let repository: BookRepositoryProtocol
    
    init(repository: BookRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, start: Int) -> Observable<[BookItem]> {
        return repository.fetchBooks(query: query, start: start)
    }
}
