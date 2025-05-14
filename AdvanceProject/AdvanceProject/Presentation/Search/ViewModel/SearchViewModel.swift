//
//  SearchViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import RxSwift
import RxRelay

final class SearchViewModel {
    private let searchBooksUseCase: SearchBooksUseCase
    private let recentBooksUseCase: RecentBooksUseCase
    private let disposeBag = DisposeBag()

    // 입력
    let searchQuery = PublishSubject<String>()

    // 출력
    let books = BehaviorSubject<[Book]>(value: [])
    let recentBooks = BehaviorSubject<[RecentBook]>(value: [])

    init(
        searchBooksUseCase: SearchBooksUseCase,
        recentBooksUseCase: RecentBooksUseCase
    ) {
        self.searchBooksUseCase = searchBooksUseCase
        self.recentBooksUseCase = recentBooksUseCase
        bind()
    }

    private func bind() {
        searchQuery
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[Book]> in
                guard let self = self else { return .just([]) }
                return self.searchBooksUseCase.execute(query: query)
                    .asObservable()
                    .catchAndReturn([])
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books.onNext(books)
            })
            .disposed(by: disposeBag)
    }

    // 최근 본 책 관련
    func fetchRecentBooks() {
        let recents = recentBooksUseCase.fetch()
        recentBooks.onNext(recents)
    }

    func deleteAllRecentBooks() {
        recentBooksUseCase.deleteAll()
        recentBooks.onNext([])
    }

    func saveToRecent(book: Book) {
        recentBooksUseCase.save(book: book)
        fetchRecentBooks()
    }
}
