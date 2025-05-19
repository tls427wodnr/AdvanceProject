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

    func searchBooks(query: String, page: Int) -> Single<[Book]> {
        return networkService.fetchSearchResult(query: query, page: page)
            .map { response in
                response.documents.map { doc in
                    Book(
                        isbn: doc.isbn,
                        title: doc.title,
                        authors: doc.authors,
                        thumbnail: doc.thumbnail,
                        price: doc.price,
                        contents: doc.contents
                    )
                }
            }
    }
}
