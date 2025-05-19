//
//  SearchBookUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation
import RxSwift

public protocol SearchBookUseCaseProtocol {
    func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)>
}

public struct SearchBookUseCase: SearchBookUseCaseProtocol {
    private let bookRepository: SearchBookRepositoryProtocol
    
    public init(bookRepository: SearchBookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    public func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)> {
        return bookRepository.searchBook(searchText: searchText, page: page)
    }
}
