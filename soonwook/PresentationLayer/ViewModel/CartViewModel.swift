//
//  CartViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation
internal import RxSwift
internal import RxRelay
import DomainLayer

final class CartViewModel: ViewModelProtocol {
//    enum Action {
//        case onAppear
//        case removeFromCart(CartItem)
//        case removeAll
//    }
//    
//    struct State {
//        var items: [CartItem] = [] {
//            didSet {
//                onChange?(items)
//            }
//        }
//        
//        var onChange: (([CartItem]) -> Void)?
//    }
//    
//    var action: ((Action) -> Void)?
//    var state = State()
    
    enum Input {
        case onAppear
        case removeFromCart(CartItem)
        case removeAll
    }
    
    struct Output {
        var items = BehaviorRelay<[CartItem]>(value: [])
    }
    
    let disposeBag = DisposeBag()
    var input = PublishRelay<Input>()
    var output = Output()
    
    private let cartItemUseCase: CartItemUseCaseProtocol
    
    init(cartItemUseCase: CartItemUseCaseProtocol) {
        self.cartItemUseCase = cartItemUseCase
        
        // prepareAction()
        bindInput()
    }
    
//    private func prepareAction() {
//        action = { [weak self] action in
//            guard let self else { return }
//            
//            switch action {
//            case .onAppear:
//                fetchCartItems()
//            case .removeFromCart(let item):
//                cartItemUseCase.removeCartItem(item)
//                state.items.removeAll { $0.isbn == item.isbn }
//            case .removeAll:
//                cartItemUseCase.removeAllCartItems()
//                state.items.removeAll()
//            }
//        }
//    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .onAppear:
                    fetchCartItems()
                case .removeFromCart(let item):
                    cartItemUseCase.removeCartItem(item)
                    var items = output.items.value
                    items.removeAll { $0.isbn == item.isbn }
                    output.items.accept(items)
                case .removeAll:
                    cartItemUseCase.removeAllCartItems()
                    output.items.accept([])
                }
            }
            .disposed(by: disposeBag)
    }
    
//    func bindCartItem(_ onChange: @escaping ([CartItem]) -> Void) {
//        state.onChange = onChange
//    }
    
    private func fetchCartItems() {
        let items = cartItemUseCase.fetchCartItems()
        // state.items = items
        output.items.accept(items)
    }
}
