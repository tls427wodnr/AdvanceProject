//
//  BookUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation
import RxSwift

public protocol BookUseCaseProtocol {
    func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)>
}

public struct BookUseCase: BookUseCaseProtocol {
    private let bookRepository: BookRepositoryProtocol
    
    public init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    public func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)> {
        return bookRepository.searchBook(searchText: searchText, page: page)
    }
}
