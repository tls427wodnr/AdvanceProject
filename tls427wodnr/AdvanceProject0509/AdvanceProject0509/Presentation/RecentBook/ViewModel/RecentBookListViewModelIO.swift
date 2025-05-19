//
//  RecentBookListViewModelIO.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

import RxSwift
import RxCocoa

// MARK: - Input

struct RecentBookListViewModelInput {
    let loadTrigger: Observable<Void>
    let addBook: Observable<BookItem>
}

// MARK: - Output

struct RecentBookListViewModelOutput {
    let books: Driver<[BookItem]>
}
