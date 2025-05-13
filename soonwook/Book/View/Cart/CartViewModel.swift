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
    
    private let cartRepository: CartRepositoryProtocol
    
    init(cartRepository: CartRepositoryProtocol) {
        self.cartRepository = cartRepository
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .onAppear:
                fetchCartItems()
            case .removeFromCart(let item):
                cartRepository.removeCartItem(isbn: item.isbn)
                state.items.removeAll { $0.isbn == item.isbn }
            case .removeAll:
                cartRepository.removeAllCartItems()
                state.items.removeAll()
            }
        }
    }
    
    func bindCartItem(_ onChange: @escaping ([CartItem]) -> Void) {
        state.onChange = onChange
    }
    
    private func fetchCartItems() {
        let items = cartRepository.fetchCartItems().map { item in
            return CartItem(isbn: item.isbn, title: item.title, author: item.author, price: item.price)
        }
        state.items = items
    }
}
