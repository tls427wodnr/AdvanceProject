//
//  SearchViewModelIO.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

import RxSwift
import RxCocoa

// MARK: - Input

struct SearchViewModelInput {
    let query: Observable<String>
    let loadMoreTrigger: Observable<Void>
}

// MARK: - Output

struct SearchViewModelOutput {
    let books: Driver<[BookItem]>
    let error: Signal<Error>
}
