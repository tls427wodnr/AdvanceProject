//
//  DetailViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/12/25.
//

import Foundation
import DomainLayer

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
    private let cartItemUseCase: CartItemUseCaseProtocol
    private let historyUseCase: HistoryUseCaseProtocol
    
    init(book: Book, cartItemUseCase: CartItemUseCaseProtocol, historyUseCase: HistoryUseCaseProtocol) {
        self.book = book
        self.cartItemUseCase = cartItemUseCase
        self.historyUseCase = historyUseCase
        
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
                guard !cartItemUseCase.isItemInCart(isbn: book.isbn) else {
                    onError?("장바구니에 있는 상품입니다.")
                    return
                }
                cartItemUseCase.addToCart(isbn: book.isbn, title: book.title, author: book.author, price: book.price)
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
        historyUseCase.recordHistory(book: book)
    }
}
