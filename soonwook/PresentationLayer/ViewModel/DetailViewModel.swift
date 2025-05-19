//
//  DetailViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/12/25.
//

import Foundation
internal import RxSwift
internal import RxRelay
import DomainLayer

final class DetailViewModel: ViewModelProtocol {
//    enum Action {
//        case onAppear
//        case addToCart
//    }
//    
//    struct State {
//        var book: Book? {
//            didSet {
//                onChange?(book)
//            }
//        }
//        
//        var onChange: ((Book?) -> Void)?
//    }
//    
//    var action: ((Action) -> Void)?
//    var onError: ((String) -> Void)?
//    var state = State()
    
    enum Input {
        case onAppear
        case addToCart
    }
    
    struct Output {
        var book = PublishRelay<Book>() // PublishRelay: 초기값 없고, 구독 이후의 값만 받음.
        var error = PublishRelay<String>()
    }
    
    let disposeBag = DisposeBag()
    var input = PublishRelay<Input>()
    var output = Output()
    
    private let book: Book
    private let cartItemUseCase: CartItemUseCaseProtocol
    private let recentBookUseCase: RecentBookUseCaseProtocol
    
    init(book: Book, cartItemUseCase: CartItemUseCaseProtocol, recentBookUseCase: RecentBookUseCaseProtocol) {
        self.book = book
        self.cartItemUseCase = cartItemUseCase
        self.recentBookUseCase = recentBookUseCase
        
        // prepareAction()
        bindInput()
    }
    
//    private func prepareAction() {
//        action = { [weak self] action in
//            guard let self else { return }
//            
//            switch action {
//            case .onAppear:
//                state.book = self.book
//                saveBook() // search view의 '최근 본 책' 업데이트를 위해 데이터 저장
//            case .addToCart:
//                guard !cartItemUseCase.isItemInCart(isbn: book.isbn) else {
//                    onError?("장바구니에 있는 상품입니다.")
//                    return
//                }
//                cartItemUseCase.addToCart(isbn: book.isbn, title: book.title, author: book.author, price: book.price)
//            }
//        }
//    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .onAppear:
                    output.book.accept(book)
                    saveBook()
                case .addToCart:
                    guard !cartItemUseCase.isItemInCart(isbn: book.isbn) else {
                        output.error.accept("장바구니에 있는 상품입니다.")
                        return
                    }
                    cartItemUseCase.addToCart(isbn: book.isbn, title: book.title, author: book.author, price: book.price)
                }
            }
            .disposed(by: disposeBag)
    }
    
//    func bindBook(_ onChange: @escaping (Book?) -> Void) {
//        state.onChange = onChange
//    }
//    
//    func bindError(_ onError: @escaping (String) -> Void) {
//        self.onError = onError
//    }
    
    private func saveBook() {
        recentBookUseCase.saveBook(book)
    }
}
