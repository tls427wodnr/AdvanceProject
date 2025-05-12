//
//  BookDetailViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

final class BookDetailViewModel {
    let book: Book
    private weak var coordinator: BookDetailCoordinator?

    init(book: Book, coordinator: BookDetailCoordinator?) {
        self.book = book
        self.coordinator = coordinator
    }

    func didTapClose() {
        coordinator?.dismiss()
    }
    
    func didTapAddBook() {
        coordinator?.didAddBookToLibrary(book)
    }
}
