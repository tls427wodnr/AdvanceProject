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
    let query = PublishRelay<String>()
    
    let books = PublishRelay<[BookItem]>()
    let error = PublishRelay<Error>()
    
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    
    init() {
        bindQueryToFetchBooks()
    }
    
    private func bindQueryToFetchBooks() {
        query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[BookItem]> in
                guard let self = self else { return .empty() }
                if query.isEmpty {
                    return .just([])
                }
                return self.networkManager.fetchBooksAPI(query: query, start: 1)
                    .catch { error in
                        self.error.accept(error)
                        return .just([])
                    }
            }
            .bind(to: books)
            .disposed(by: disposeBag)
    }
}
