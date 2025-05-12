//
//  BookSearchUseCase.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/12/25.
//

import Foundation
import RxSwift

protocol SearchBooksUseCaseProtocol: AnyObject {
    func searchBooks(query: String) -> Single<[Book]>
}

final class SearchBooksUseCase: SearchBooksUseCaseProtocol {
    private let bookRepository: BookRepositoryProtocol

    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }

    func searchBooks(query: String) -> Single<[Book]> {
        bookRepository.searchBooks(query: query) // 단일 표현식 return 생략 가능
    }
}
