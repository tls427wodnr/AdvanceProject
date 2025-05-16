//
//  BookListDIContainer.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

// MARK: - BookListDIContainer

final class BookListDIContainer {

    // MARK: - Dependency Injection

    func makeBookListViewModel() -> BookListViewModelProtocol {
        let repository = LocalBookRepository()
        let useCase = LocalBookUseCase(repository: repository)
        return BookListViewModel(useCase: useCase)
    }
}
