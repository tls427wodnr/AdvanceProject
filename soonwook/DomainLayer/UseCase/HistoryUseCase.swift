//
//  HistoryUseCase.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation

public protocol HistoryUseCaseProtocol {
    func recordHistory(book: Book)
    func fetchHistories() -> [History]
}

public struct HistoryUseCase: HistoryUseCaseProtocol {
    private let historyRepository: HistoryRepositoryProtocol
    
    public init(historyRepository: HistoryRepositoryProtocol) {
        self.historyRepository = historyRepository
    }
    
    public func recordHistory(book: Book) {
        // 이미 저장되어 있으면 날짜만 최신으로 업데이트 후 리턴
        guard !historyRepository.isHistoryExist(isbn: book.isbn) else {
            historyRepository.updateHistory(isbn: book.isbn)
            return
        }
        
        historyRepository.deleteHistory() // 현재 저장된 총 개수를 10개 미만으로 유지
        
        historyRepository.recordHistory(isbn: book.isbn, title: book.title, authors: book.authors, price: book.price, contents: book.contents, thumbnail: book.thumbnail)
    }
    
    public func fetchHistories() -> [History] {
        let histories = historyRepository.fetchHistories().map { history in
            return History(isbn: history.isbn, title: history.title, authors: history.authors, price: history.price, contents: history.contents, thumbnail: history.thumbnail, timestamp: history.timestamp)
        }
        return histories
    }
}
