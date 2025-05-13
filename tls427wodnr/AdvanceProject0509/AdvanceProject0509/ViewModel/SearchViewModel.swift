//
//  SearchViewModel.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {

    // MARK: - Input

    struct Input {
        let query: Observable<String>
        let loadMoreTrigger: Observable<Void>
    }

    // MARK: - Output
    
    struct Output {
        let books: Driver<[BookItem]>
        let error: Signal<Error>
    }
    
    // MARK: - Properties

    private let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    private let errorRelay = PublishRelay<Error>()
    private let disposeBag = DisposeBag()
    private let networkManager: NetworkManager
    
    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var isLoading = false
    
    // MARK: - Init

    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        input.query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .do(onNext: { [weak self] newQuery in
                self?.currentQuery = newQuery
                self?.currentPage = 1
            })
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[BookItem]> in
                guard let self = self else { return .empty() }
                
                if query.isEmpty {
                    return .just([])
                }
                
                return self.networkManager.fetchBooksAPI(query: query, start: 1)
                    .do(
                         onSubscribe: { [weak self] in self?.isLoading = true },
                         onDispose: { [weak self] in self?.isLoading = false }
                     )
                    .catch { [weak self] error in
                        self?.errorRelay.accept(error)
                        return .just([])
                    }
            }
            .bind(to: booksRelay)
            .disposed(by: disposeBag)
        
        input.loadMoreTrigger
                    .observe(on: MainScheduler.instance)
                    .filter { [weak self] in
                        guard let self = self else { return false }
                        return !self.isLoading && !self.currentQuery.isEmpty
                    }
                    .flatMapLatest { [weak self] _ -> Observable<[BookItem]> in
                        guard let self = self else { return .empty() }
                        
                        self.isLoading = true
                        self.currentPage += 1
                        let nextPage = 1 + (currentPage - 1) * 30

                        return self.networkManager.fetchBooksAPI(query: self.currentQuery, start: nextPage)
                            .do(
                                 onSubscribe: { [weak self] in self?.isLoading = true },
                                 onDispose: { [weak self] in self?.isLoading = false }
                             )
                            .catch { [weak self] error in
                                self?.errorRelay.accept(error)
                                return .just([])
                            }
                    }
                    .subscribe(onNext: { [weak self] additionalBooks in
                        guard let self = self else { return }
                        let combined = self.booksRelay.value + additionalBooks
                        self.booksRelay.accept(combined)
                    })
                    .disposed(by: disposeBag)

        return Output(
            books: booksRelay.asDriver(),
            error: errorRelay.asSignal()
        )
    }
}
