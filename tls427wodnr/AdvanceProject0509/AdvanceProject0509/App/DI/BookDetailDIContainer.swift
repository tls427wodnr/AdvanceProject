//
//  BookDetailDIContainer.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

// MARK: - BookDetailDIContainer

final class BookDetailDIContainer {
    
    // MARK: - Dependency Injection

    func makeBookDetailViewModel(book: BookItem) -> BookDetailBottomSheetViewModelProtocol {
        let repository = LocalBookRepository()
        let useCase = LocalBookUseCase(repository: repository)
        return BookDetailBottomSheetViewModel(book: book, useCase: useCase)
    }
}
