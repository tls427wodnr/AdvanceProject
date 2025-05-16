//
//  BookDetailBottomSheetViewModelIO.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

import RxSwift
import RxCocoa

// MARK: - Input

struct BookDetailBottomSheetViewModelInput {
    let addTrigger: Observable<Void>
}

// MARK: - Output

struct BookDetailBottomSheetViewModelOutput {
    let added: Driver<Void>
    let error: Driver<String>
}
