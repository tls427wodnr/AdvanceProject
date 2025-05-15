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
        case onAppear
        case searchBook(String)
        case onDismissDetailView
    }
    
    struct State {
        var books: [Book] = [] {
            didSet {
                onChange?(books)
            }
        }
        
        var histories: [History] = [] {
            didSet {
                onHistoryChange?(histories)
            }
        }
        
        var error: Error? {
            didSet {
                onError?(error)
            }
        }
        
        var searchText = ""
        
        var onChange: (([Book]) -> Void)?
        var onHistoryChange: (([History]) -> Void)?
        var onError: ((Error?) -> Void)?
    }
    
    var action: ((Action) -> Void)?
    var state = State()
    
    private let bookRepository: BookRepositoryProtocol
    let cartRepository: CartRepositoryProtocol
    let historyRepository: HistoryRepositoryProtocol
    
    init(bookRepository: BookRepositoryProtocol, cartRepository: CartRepositoryProtocol, historyRepository: HistoryRepositoryProtocol) {
        self.bookRepository = bookRepository
        self.cartRepository = cartRepository
        self.historyRepository = historyRepository
        
        prepareAction()
    }
    
    private func prepareAction() {
        action = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .onAppear, .onDismissDetailView:
                fetchHistories()
            case .searchBook(let searchText):
                state.searchText = searchText
                searchBook(searchText: searchText)
            }
        }
    }
    
    private func fetchHistories(){
        let histories = historyRepository.fetchHistories().map { history in
            return History(isbn: history.isbn, title: history.title, authors: history.authors, price: history.price, contents: history.contents, thumbnail: history.thumbnail, timestamp: history.timestamp)
        }
        state.histories = sortHistories(histories)
    }
    
    private func sortHistories(_ histories: [History]) -> [History] {
        histories.sorted(by: { $0.timestamp > $1.timestamp })
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
    
    func bindHistory(_ onChange: @escaping ([History]) -> Void) {
        state.onHistoryChange = onChange
    }
    
    func bindError(_ onError: @escaping (Error?) -> Void) {
        state.onError = onError
    }
}
