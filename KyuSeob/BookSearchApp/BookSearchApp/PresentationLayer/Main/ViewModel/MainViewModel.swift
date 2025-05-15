//
//  MainViewModel.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let searchBooksUseCase: SearchBooksUseCaseProtocol
    private let recentBooksUseCase: RecentBooksUseCaseProtocol

    let searchResultBooks = BehaviorRelay<[Book]>(value: [])
    let recentBooks = BehaviorRelay<[RecentBook]>(value: [])
    let didFailedEvent = PublishRelay<Error>()
    let fetchRecentBooks = PublishRelay<Void>()
    let searchTrigger = PublishRelay<Void>()

    private var currentPage = 1
    private var isLastPage = false
    var query: String = ""

    private let disposeBag = DisposeBag()

    var sections: Observable<[BookSection]> {
        Observable.combineLatest(recentBooks, searchResultBooks)
            .map { recentBooks, searchBooks -> [BookSection] in
                return [
                    .recent(recentBooks.map { BookSectionItem.recent($0) }),
                    .search(searchBooks.map { BookSectionItem.search($0) })
                ]
            }
    }

    init(
        searchBooksUseCase: SearchBooksUseCaseProtocol,
        recentBooksUseCase: RecentBooksUseCaseProtocol
    ) {
        self.searchBooksUseCase = searchBooksUseCase
        self.recentBooksUseCase = recentBooksUseCase

        bind()
    }
}

extension MainViewModel {
    func searchBooks(with query: String, of page: Int) {
        if query != self.query {
            currentPage = 1
            isLastPage = false
            searchResultBooks.accept([])
        }
        self.query = query

        searchBooksUseCase.searchBooks(query: query, page: currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                guard let self else { return }
                let existing = self.searchResultBooks.value
                let combined = existing + result
                self.searchResultBooks.accept(combined)

                self.isLastPage = result.isEmpty
            }, onFailure: { error in
                self.didFailedEvent.accept(error)
            }).disposed(by: disposeBag)

    }

    func bind() {
        fetchRecentBooks
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                do {
                    let recentBooks = try self.recentBooksUseCase.fetchRecentBooks()
                    print("최근 본 책 개수: \(recentBooks.count)")
                    self.recentBooks.accept(recentBooks)
                } catch {
                    print(error)
                }
            }).disposed(by: disposeBag)

        searchTrigger
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                if !isLastPage {
                    currentPage += 1
                    searchBooks(with: query, of: currentPage)
                }
            }).disposed(by: disposeBag)
    }
}
