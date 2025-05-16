//
//  RecentBookUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation

public protocol RecentBookUseCaseProtocol {
    func saveBook(_ book: Book)
    func fetchBook() -> [Book]
}

public struct RecentBookUseCase: RecentBookUseCaseProtocol {
    private let recentBookRepository: RecentBookRepositoryProtocol
    
    public init(recentBookRepository: RecentBookRepositoryProtocol) {
        self.recentBookRepository = recentBookRepository
    }
    
    public func saveBook(_ book: Book) {
        // 이미 저장되어 있으면 날짜만 최신으로 업데이트 후 리턴
        guard !recentBookRepository.isBookExist(isbn: book.isbn) else {
            recentBookRepository.updateBook(isbn: book.isbn)
            return
        }
        
        recentBookRepository.deleteBookIfNeeded() // 현재 저장된 총 개수를 10개 미만으로 유지
        
        recentBookRepository.saveBook(isbn: book.isbn, title: book.title, authors: book.authors, price: book.price, contents: book.contents, thumbnail: book.thumbnail)
    }
    
    public func fetchBook() -> [Book] {
        let books = recentBookRepository.fetchBook().map { history in
            return Book(isbn: history.isbn, title: history.title, authors: history.authors, price: history.price, contents: history.contents, thumbnail: history.thumbnail, timestamp: history.timestamp)
        }
        return books
    }
}
