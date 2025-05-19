//
//  LocalBookUseCase.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

// MARK: - LocalBookUseCase

final class LocalBookUseCase: LocalBookUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: LocalBookRepositoryProtocol
    
    // MARK: - Initializer
    
    init(repository: LocalBookRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func save(_ item: BookItem) -> Completable {
        repository.save(item)
    }
    
    func fetchAll() -> Single<[BookItem]> {
        repository.fetchAll()
    }
    
    func delete(isbn: String) -> Completable {
        repository.delete(isbn: isbn)
    }
    
    func deleteAll() -> Completable {
        repository.deleteAll()
    }
}
