//
//  BookRepositoryImpl.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import RxSwift

final class BookRepositoryImpl: BookRepository {
    private let service: BookAPIService

    init(service: BookAPIService) {
        self.service = service
    }

    func searchBooks(query: String, page: Int) -> Single<BookSearchResponseDTO> {
        return service.searchBooks(query: query, page: page)
    }
}

