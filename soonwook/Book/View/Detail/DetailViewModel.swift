//
//  DetailViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/12/25.
//

import Foundation

final class DetailViewModel: ViewModelProtocol {
    enum Action {
        case onAppear
        case addToCart
    }
    
    struct State {
        var book: Book? {
            didSet {
                onChange?(book)
            }
        }
        
        var onChange: ((Book?) -> Void)?
    }
    
    var action: ((Action) -> Void)?
    var onError: ((String) -> Void)?
    var state = State()
    
    private let book: Book
    private let cartRepository: CartRepositoryProtocol
    private let historyRepository: HistoryRepositoryProtocol
    
    init(book: Book, cartRepository: CartRepositoryProtocol, historyRepository: HistoryRepositoryProtocol) {
        self.book = book
        self.cartRepository = cartRepository
        self.historyRepository = historyRepository
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .onAppear:
                state.book = self.book
                recordHistory() // search view의 '최근 본 책' 업데이트를 위해 데이터 저장
            case .addToCart:
                guard !cartRepository.isItemInCart(isbn: book.isbn) else {
                    onError?("장바구니에 있는 상품입니다.")
                    return
                }
                cartRepository.addToCart(isbn: book.isbn, title: book.title, author: book.author, price: book.price)
            }
        }
    }
    
    func bindBook(_ onChange: @escaping (Book?) -> Void) {
        state.onChange = onChange
    }
    
    func bindError(_ onError: @escaping (String) -> Void) {
        self.onError = onError
    }
    
    private func recordHistory() {
        // 이미 저장되어 있으면 날짜만 최신으로 업데이트 후 리턴
        guard !historyRepository.isHistoryExist(isbn: book.isbn) else {
            historyRepository.updateHistory(isbn: book.isbn)
            return
        }
        
        historyRepository.deleteHistory() // 현재 저장된 총 개수를 10개 미만으로 유지
        
        historyRepository.recordHistory(isbn: book.isbn, title: book.title, authors: book.authors, price: book.price, contents: book.contents, thumbnail: book.thumbnail)
    }
}
