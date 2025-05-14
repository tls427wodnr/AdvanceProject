//
//  LocalRecentBookUseCase.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

final class LocalRecentBookUseCase: LocalRecentBookUseCaseProtocol {
    private let repository: LocalRecentBookRepositoryProtocol

    init(repository: LocalRecentBookRepositoryProtocol) {
        self.repository = repository
    }

    func loadRecentBooks() -> Single<[BookItem]> {
        return repository.load()
    }

    func addRecentBook(_ book: BookItem) -> Completable {
        return repository.save(book)
    }
}
