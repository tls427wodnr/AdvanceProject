//
//  StoredBooksViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation
import RxSwift
import RxRelay

final class StoredBooksViewModel {

    private let useCase: StoredBooksUseCase
    private let disposeBag = DisposeBag()

    // Output
    let books = BehaviorRelay<[Book]>(value: [])
    let removedBook = PublishRelay<Book>()

    init(useCase: StoredBooksUseCase) {
        self.useCase = useCase
    }

    func fetchStoredBooks() {
        books.accept(useCase.fetch())
    }

    func remove(at index: Int) {
        var current = books.value
        let book = current[index]
        useCase.remove(book: book)
        current.remove(at: index)
        books.accept(current)
        removedBook.accept(book)
    }

    func clearAll() {
        useCase.clear()
        books.accept([])
    }
}


