//
//  CartViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation

final class CartViewModel: ViewModelProtocol {
    enum Action {
        case onAppear
        case removeFromCart(CartItem)
        case removeAll
    }
    
    struct State {
        var items: [CartItem] = [] {
            didSet {
                onChange?(items)
            }
        }
        
        var onChange: (([CartItem]) -> Void)?
    }
    
    var action: ((Action) -> Void)?
    var state = State()
    
    private let cartItemUseCase: CartItemUseCaseProtocol
    
    init(cartItemUseCase: CartItemUseCaseProtocol) {
        self.cartItemUseCase = cartItemUseCase
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .onAppear:
                fetchCartItems()
            case .removeFromCart(let item):
                cartItemUseCase.removeCartItem(item)
                state.items.removeAll { $0.isbn == item.isbn }
            case .removeAll:
                cartItemUseCase.removeAllCartItems()
                state.items.removeAll()
            }
        }
    }
    
    func bindCartItem(_ onChange: @escaping ([CartItem]) -> Void) {
        state.onChange = onChange
    }
    
    private func fetchCartItems() {
        let items = cartItemUseCase.fetchCartItems()
        state.items = items
    }
}
