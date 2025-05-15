//
//  FetchBooksUseCaseProtocol.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

// MARK: - FetchBooksUseCaseProtocol

protocol FetchBooksUseCaseProtocol {
    func execute(query: String, start: Int) -> Observable<[BookItem]>
}
