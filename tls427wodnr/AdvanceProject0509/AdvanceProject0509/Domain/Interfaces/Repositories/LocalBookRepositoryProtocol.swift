//
//  LocalBookRepositoryProtocol.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

// MARK: - LocalBookRepositoryProtocol

protocol LocalBookRepositoryProtocol {
    func save(_ item: BookItem) -> Completable
    func fetchAll() -> Single<[BookItem]>
    func delete(isbn: String) -> Completable
    func deleteAll() -> Completable
}
