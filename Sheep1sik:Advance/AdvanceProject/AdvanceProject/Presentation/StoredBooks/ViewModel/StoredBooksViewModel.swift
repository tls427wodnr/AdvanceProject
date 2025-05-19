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

    func remove(book: Book) {
        useCase.remove(book: book)
        books.accept(books.value.filter { $0.isbn != book.isbn })
        removedBook.accept(book)
    }

    func clearAll() {
        useCase.clear()
        books.accept([])
    }

    func book(at index: Int) -> Book? {
        guard books.value.indices.contains(index) else { return nil }
        return books.value[index]
    }
}


