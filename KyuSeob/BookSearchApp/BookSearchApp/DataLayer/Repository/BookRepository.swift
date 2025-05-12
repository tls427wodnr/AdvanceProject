//
//  SearchBookRepository.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation
import RxSwift

final class BookRepository: BookRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func searchBooks(query: String) -> Single<[Book]> {
        return networkService.fetchSearchResult(query: query)
            .map { response in
                response.documents.map { doc in
                    Book(
                        title: doc.title,
                        authors: doc.authors,
                        price: doc.price
                    )
                }
            }
    }
}
