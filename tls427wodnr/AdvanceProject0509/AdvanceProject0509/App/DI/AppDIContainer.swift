//
//  AppDIContainer.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

final class AppDIContainer {

    // MARK: - Shared
    
    private let networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - ViewModel Factories

    func makeSearchViewModel() -> SearchViewModelProtocol {
        let repository = BookRepository(networkService: networkService)
        let useCase = FetchBooksUseCase(repository: repository)
        return SearchViewModel(fetchBooksUseCase: useCase)
    }

    func makeBookListViewModel() -> BookListViewModelProtocol {
        let repository = LocalBookRepository()
        let useCase = LocalBookUseCase(repository: repository)
        return BookListViewModel(useCase: useCase)
    }

    func makeBookDetailViewModel(book: BookItem) -> BookDetailBottomSheetViewModelProtocol {
        let repository = LocalBookRepository()
        let useCase = LocalBookUseCase(repository: repository)
        return BookDetailBottomSheetViewModel(book: book, useCase: useCase)
    }

    func makeRecentBookListViewModel() -> RecentBookListViewModel {
        let repository = LocalRecentBookRepository()
        let useCase = LocalRecentBookUseCase(repository: repository)
        return RecentBookListViewModel(useCase: useCase)
    }
}
