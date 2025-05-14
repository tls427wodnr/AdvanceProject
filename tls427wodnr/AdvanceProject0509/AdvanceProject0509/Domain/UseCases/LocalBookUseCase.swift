//
//  LocalBookUseCase.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

final class LocalBookUseCase: LocalBookUseCaseProtocol {
    
    private let repository: LocalBookRepositoryProtocol
    
    init(repository: LocalBookRepositoryProtocol) {
        self.repository = repository
    }
    
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
