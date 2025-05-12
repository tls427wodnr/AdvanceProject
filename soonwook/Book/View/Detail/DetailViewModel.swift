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
    
    let book: Book
    
    var action: ((Action) -> Void)?
    var state = State()
    
    init(book: Book) {
        self.book = book
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .onAppear:
                state.book = self.book
            case .addToCart:
                print("Add to cart: \(book.title)")
            }
        }
    }
    
    func bindBook(_ onChange: @escaping (Book?) -> Void) {
        state.onChange = onChange
    }
}
