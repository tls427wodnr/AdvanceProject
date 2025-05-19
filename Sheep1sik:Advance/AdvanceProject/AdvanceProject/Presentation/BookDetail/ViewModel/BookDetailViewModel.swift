//
//  BookDetailViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//
import RxSwift

final class BookDetailViewModel {
    let book: Book
    private weak var coordinator: BookDetailCoordinator?
    private let useCase: BookDetailUseCase

    init(book: Book, coordinator: BookDetailCoordinator?, useCase: BookDetailUseCase) {
        self.book = book
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func tryAddBook() -> Observable<AddBookResult> {
        useCase.tryAdd(book: book)
    }

    func didTapAddBook() {
        coordinator?.dismiss()
    }

    func didTapClose() {
        coordinator?.dismiss()
    }
}


