//
//  SearchViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var action: ((Action) -> Void)? { get }
    var state: State { get }
}

final class SearchViewModel: ViewModelProtocol {
    enum Action {
        case searchBook(String)
    }
    
    struct State {
        var books: [Book] = [] {
            didSet {
                onChange?(books)
            }
        }
        
        var error: Error? {
            didSet {
                onError?(error)
            }
        }
        
        var searchText = ""
        
        var onChange: (([Book]) -> Void)?
        var onError: ((Error?) -> Void)?
    }
    
    var action: ((Action) -> Void)?
    var state = State()
    
    private let bookRepository: BookRepositoryProtocol
    let cartRepository: CartRepositoryProtocol
    
    init(bookRepository: BookRepositoryProtocol, cartRepository: CartRepositoryProtocol) {
        self.bookRepository = bookRepository
        self.cartRepository = cartRepository
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .searchBook(let searchText):
                state.searchText = searchText
                searchBook(searchText: searchText)
            }
        }
    }
    
    private func searchBook(searchText: String) {
        bookRepository.searchBook(searchText: searchText) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let books):
                state.books = books
            case .failure(let error):
                state.error = error
            }
        }
    }
    
    func bindBook(_ onChange: @escaping ([Book]) -> Void) {
        state.onChange = onChange
    }
    
    func bindError(_ onError: @escaping (Error?) -> Void) {
        state.onError = onError
    }
}
