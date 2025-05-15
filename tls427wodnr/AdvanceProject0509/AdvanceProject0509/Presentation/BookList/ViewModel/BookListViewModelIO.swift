//
//  BookListViewModelIO.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

import RxSwift
import RxCocoa

// MARK: - Input

struct BookListViewModelInput {
    let loadTrigger: Observable<Void>
    let deleteTrigger: Observable<String>
    let deleteAllTrigger: Observable<Void>
}

// MARK: - Output

struct BookListViewModelOutput {
    let books: Driver<[BookItem]>
    let error: Driver<String>
}
