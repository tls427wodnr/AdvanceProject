//
//  SearchFocusEvent.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import RxSwift
import RxCocoa

final class SearchFocusEvent {
    static let shared = SearchFocusEvent()
    let focusTrigger = PublishRelay<Void>()
    private init() {}
}
