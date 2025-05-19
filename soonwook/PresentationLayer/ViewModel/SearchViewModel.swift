//
//  SearchViewModel.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation
internal import RxSwift
internal import RxRelay
import DomainLayer

//protocol ViewModelProtocol {
//    associatedtype Action
//    associatedtype State
//    
//    var action: ((Action) -> Void)? { get }
//    var state: State { get }
//}

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
}

final class SearchViewModel: ViewModelProtocol {
//    enum Action {
//        case onAppear
//        case searchBook(String)
//        case onScrollEnd
//    }
//    
//    struct State {
//        var books: [Book] = [] {
//            didSet {
//                onChange?(books)
//            }
//        }
//        
//        var recentBooks: [Book] = [] {
//            didSet {
//                onRecentBookChange?(recentBooks)
//            }
//        }
//        
//        var error: Error? {
//            didSet {
//                onError?(error)
//            }
//        }
//        
//        var searchText = ""
//        var meta: Meta? // API 수신 메타 데이터
//        
//        var onChange: (([Book]) -> Void)?
//        var onRecentBookChange: (([Book]) -> Void)?
//        var onError: ((Error?) -> Void)?
//    }
//    
//    var action: ((Action) -> Void)?
//    var state = State()
    
    enum Input {
        case onAppear
        case searchBook(String)
        case onScrollEnd
    }
    
    struct Output {
        var books = BehaviorRelay<[Book]>(value: [])
        var recentBooks = BehaviorRelay<[Book]>(value: [])
        var error = PublishRelay<Error>()
        
        var searchText = BehaviorRelay(value: "")
        var meta = BehaviorRelay<Meta?>(value: nil)
    }
    
    let disposeBag = DisposeBag()
    var input = PublishRelay<Input>()
    var output = Output()
    
    private let searchBookUseCase: SearchBookUseCaseProtocol
    let cartItemUseCase: CartItemUseCaseProtocol
    let recentBookUseCase: RecentBookUseCaseProtocol
    
    private var currentPage = 1
    private var isLoading = false
    
    init(searchBookUseCase: SearchBookUseCaseProtocol, cartItemUseCase: CartItemUseCaseProtocol, recentBookUseCase: RecentBookUseCaseProtocol) {
        self.searchBookUseCase = searchBookUseCase
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
//                fetchBook()
//            case .searchBook(let searchText):
//                resetSearchState()
//                
//                state.searchText = searchText
//                searchBook(searchText: searchText, page: currentPage)
//            case .onScrollEnd:
//                guard let meta = state.meta else { return }
//                
//                if !meta.isEnd {
//                    currentPage += 1
//                    searchBook(searchText: state.searchText, page: currentPage)
//                }
//            }
//        }
//    }
    
    private func bindInput() {
        input
            .subscribe { [weak self] input in
                guard let self else { return }
                
                switch input {
                case .onAppear:
                    fetchBook()
                case .searchBook(let searchText):
                    resetSearchState()
                    
                    output.searchText.accept(searchText)
                    searchBook(searchText: searchText, page: currentPage)
                case .onScrollEnd:
                    guard let isEnd = output.meta.value?.isEnd else { return }
                    
                    if !isEnd {
                        currentPage += 1
                        searchBook(searchText: output.searchText.value, page: currentPage)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchBook(){
        let recentBooks = recentBookUseCase.fetchBook()
        // state.recentBooks = sortBook(recentBooks)
        output.recentBooks.accept(sortBook(recentBooks))
    }
    
    private func sortBook(_ books: [Book]) -> [Book] {
        books.sorted(by: { $0.timestamp! > $1.timestamp! })
    }
    
    private func resetSearchState() {
        currentPage = 1
        // state.meta = nil
        output.meta.accept(nil)
    }
    
    // 무한 스크롤 구현 전: book 데이터만 수신, page 쿼리 불가
//    private func searchBook(searchText: String) {
//        searchBookRepository.searchBook(searchText: searchText) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let books):
//                state.books = books
//            case .failure(let error):
//                state.error = error
//            }
//        }
//    }
    
    // 무한 스크롤 구현 후: book 데이터와 meta 데이터 수신, page 쿼리 가능, RxSwift 이용
    private func searchBook(searchText: String, page: Int) {
        guard !isLoading else { return }
        isLoading = true
        
        searchBookUseCase.searchBook(searchText: searchText, page: page)
            .subscribe { [weak self] response in
                guard let self else { return }
                
                if currentPage == 1 {
                    // state.books = response.books
                    output.books.accept(response.books)
                } else {
                    // state.books += response.books
                    let books = output.books.value + response.books
                    output.books.accept(books)
                }
                // state.meta = response.meta
                output.meta.accept(response.meta)
                isLoading = false
            } onFailure: { [weak self] error in
                // self?.state.error = error
                self?.output.error.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
//    func bindBook(_ onChange: @escaping ([Book]) -> Void) {
//        state.onChange = onChange
//    }
//    
//    func bindRecentBook(_ onChange: @escaping ([Book]) -> Void) {
//        state.onRecentBookChange = onChange
//    }
//    
//    func bindError(_ onError: @escaping (Error?) -> Void) {
//        state.onError = onError
//    }
}
