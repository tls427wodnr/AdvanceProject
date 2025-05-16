//
//  SearchFocusEvent.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import RxSwift
import RxCocoa

// MARK: - SearchFocusEvent

final class SearchFocusEvent {

    // MARK: - Singleton

    static let shared = SearchFocusEvent()
    
    // MARK: - Trigger

    let focusTrigger = PublishRelay<Void>()
    
    // MARK: - Initializer

    private init() {}
}
