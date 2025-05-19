//
//  BookSearchViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BookSearchViewModel {
    struct Input {
        let searchTrigger: Observable<String>
        let reachedBottomTrigger: Observable<Void>
    }
    
    struct Output {
        let sectionedBooks: Driver<[BookSectionModel]>
        let errorMessage: Signal<String>
    }
    
    private let bookSearchUseCase: BookSearchUseCase
    private let fetchRecentBooksUseCase: FetchRecentBooksUseCase
    
    private let bookSearchResults = BehaviorRelay<[Book]>(value: [])
    private let recentBooks = BehaviorRelay<[Book]>(value: [])
    private let errorMessageRelay = PublishRelay<String>()
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private var currentQuery = ""
    private var currentPage = 1
    private var isEnd = false
    
    private let disposeBag = DisposeBag()
    
    init(
        bookSearchUseCase: BookSearchUseCase,
        fetchRecentBooksUseCase: FetchRecentBooksUseCase
    ) {
        self.bookSearchUseCase = bookSearchUseCase
        self.fetchRecentBooksUseCase = fetchRecentBooksUseCase
    }
    
    func transform(input: Input) -> Output {
        input.searchTrigger
            .subscribe(onNext: { [weak self] query in
                self?.startSearch(query: query)
            })
            .disposed(by: disposeBag)
        
        input.reachedBottomTrigger
            .subscribe(onNext: { [weak self] in
                self?.loadNextPage()
            })
            .disposed(by: disposeBag)
        
        let sectionedBooks = Observable
            .combineLatest(recentBooks, bookSearchResults)
            .map { recent, search in
                return [
                    BookSectionModel(type: .recent, header: "최근 본 책", items: recent),
                    BookSectionModel(type: .searchResult, header: "검색 결과", items: search)
                ]
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            sectionedBooks: sectionedBooks,
            errorMessage: errorMessageRelay.asSignal()
        )
    }
    
    private func startSearch(query: String) {
        guard !query.isEmpty else { return }
        
        isLoadingRelay.accept(true)
        currentQuery = query
        currentPage = 1
        
        bookSearchUseCase.execute(query: query, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] books in
                    guard let self else { return }
                    self.bookSearchResults.accept(books)
                    self.isEnd = books.isEmpty
                    self.currentPage += 1
                    self.isLoadingRelay.accept(false)
                },
                onFailure: { [weak self] error in
                    self?.errorMessageRelay.accept("검색 실패: \(error.localizedDescription)")
                    self?.isLoadingRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func loadNextPage() {
        guard !isEnd, !isLoadingRelay.value else { return }
        
        isLoadingRelay.accept(true)
        
        bookSearchUseCase.execute(query: currentQuery, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] books in
                    guard let self else { return }
                    let current = self.bookSearchResults.value
                    self.bookSearchResults.accept(current + books)
                    self.isEnd = books.isEmpty
                    self.currentPage += 1
                    self.isLoadingRelay.accept(false)
                }, onFailure: { [weak self] error in
                    self?.errorMessageRelay.accept("페이지 로드 실패: \(error.localizedDescription)")
                    self?.isLoadingRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchRecentBooks() {
        fetchRecentBooksUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] books in
                    self?.recentBooks.accept(books)
                }, onFailure: { [weak self] error in
                    self?.errorMessageRelay.accept("최근 본 책 로드 실패: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}
