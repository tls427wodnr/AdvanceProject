//
//  BookUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation
import RxSwift

protocol BookUseCaseProtocol {
    func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)>
}

final class BookUseCase: BookUseCaseProtocol {
    private let bookRepository: BookRepositoryProtocol
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)> {
        return bookRepository.searchBook(searchText: searchText, page: page)
    }
}
