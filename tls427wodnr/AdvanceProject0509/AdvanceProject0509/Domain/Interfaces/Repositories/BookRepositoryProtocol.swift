//
//  BookRepositoryProtocol.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import RxSwift

protocol BookRepositoryProtocol {
    func fetchBooks(query: String, start: Int) -> Observable<[BookItem]>
}
