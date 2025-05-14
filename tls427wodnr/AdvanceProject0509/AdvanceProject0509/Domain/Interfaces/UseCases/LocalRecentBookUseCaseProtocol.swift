//
//  LocalRecentBookUseCaseProtocol.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

protocol LocalRecentBookUseCaseProtocol {
    func loadRecentBooks() -> Single<[BookItem]>
    func addRecentBook(_ book: BookItem) -> Completable
}
