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
    
    init(book: Book, cartRepository: CartRepositoryProtocol) {
        self.book = book
        self.cartRepository = cartRepository
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .onAppear:
                state.book = self.book
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
}
