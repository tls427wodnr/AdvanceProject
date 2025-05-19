//
//  LocalRecentBookUseCase.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

// MARK: - LocalRecentBookUseCase

final class LocalRecentBookUseCase: LocalRecentBookUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: LocalRecentBookRepositoryProtocol

    // MARK: - Initializer
    
    init(repository: LocalRecentBookRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Methods
    
    func loadRecentBooks() -> Single<[BookItem]> {
        return repository.load()
    }

    func addRecentBook(_ book: BookItem) -> Completable {
        return repository.save(book)
    }
}
