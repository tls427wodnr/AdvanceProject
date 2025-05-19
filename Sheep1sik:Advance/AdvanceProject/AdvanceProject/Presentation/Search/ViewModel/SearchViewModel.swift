//
//  SearchViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import RxSwift
import RxRelay

final class SearchViewModel {

    // MARK: - Dependencies
    private let searchBooksUseCase: SearchBooksUseCase
    private let recentBooksUseCase: RecentBooksUseCase
    private let disposeBag = DisposeBag()

    // MARK: - State
    private var currentPage = 1
    private var isEnd = false
    private var isLoading = false
    private var lastQuery = ""

    // MARK: - Input
    let searchQuery = PublishSubject<String>()

    // MARK: - Output
    let books = BehaviorRelay<[Book]>(value: [])
    let recentBooks = BehaviorSubject<[RecentBook]>(value: [])

    // MARK: - Init
    init(
        searchBooksUseCase: SearchBooksUseCase,
        recentBooksUseCase: RecentBooksUseCase
    ) {
        self.searchBooksUseCase = searchBooksUseCase
        self.recentBooksUseCase = recentBooksUseCase
        bind()
    }

    // MARK: - Binding
    private func bind() {
        searchQuery
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[Book]> in
                guard let self = self else { return .just([]) }

                self.lastQuery = query
                self.currentPage = 1
                self.isEnd = false

                return self.searchBooksUseCase.execute(query: query, page: 1)
                    .map { response in
                        self.isEnd = response.meta.is_end
                        return response.documents.map { $0.toEntity() }
                    }
                    .asObservable()
                    .catchAndReturn([])
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books.accept(books)
            })
            .disposed(by: disposeBag)
    }


    // MARK: - Infinite Scroll
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard !isEnd, !isLoading, currentIndex >= books.value.count - 5 else { return }

        isLoading = true
        searchBooksUseCase.execute(query: lastQuery, page: currentPage + 1)
            .map { [weak self] response in
                self?.isEnd = response.meta.is_end
                return response.documents.map { $0.toEntity() }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] newBooks in
                guard let self = self else { return }
                self.currentPage += 1
                self.books.accept(self.books.value + newBooks)
                self.isLoading = false
            }, onFailure: { [weak self] _ in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Recent Book Handling
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
    
    deinit {
        print("deinitialized")
    }
}
