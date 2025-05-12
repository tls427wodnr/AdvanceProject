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
    private let networkManager = NetworkManager.shared

    // MARK: - Transform

    func transform(input: Input) -> Output {
        input.query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[BookItem]> in
                guard let self = self else { return .empty() }
                if query.isEmpty {
                    return .just([])
                }
                return self.networkManager.fetchBooksAPI(query: query, start: 1)
                    .catch { [weak self] error in
                        self?.errorRelay.accept(error)
                        return .just([])
                    }
            }
            .bind(to: booksRelay)
            .disposed(by: disposeBag)

        return Output(
            books: booksRelay.asDriver(),
            error: errorRelay.asSignal()
        )
    }
}
