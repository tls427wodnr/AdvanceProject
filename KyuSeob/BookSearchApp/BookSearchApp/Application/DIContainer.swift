//
//  DIContainer.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/18/25.
//

import Foundation

final class DIContainer {
    private let networkService: NetworkServiceProtocol
    private let coreDataStorage: CoreDataStorageProtocol
    private let bookRepository: BookRepositoryProtocol
    private let cartBookRepository: CartBookRepositoryProtocol
    private let recentBookRepository: RecentBookRepositoryProtocol
    private let cartBookUseCase: CartBookUseCaseProtocol
    private let recentBooksUseCase: RecentBooksUseCaseProtocol
    private let searchBooksUseCase: SearchBooksUseCaseProtocol

    init() {
        self.networkService = NetworkService()
        self.coreDataStorage = CoreDataStorage()

        self.bookRepository = BookRepository(networkService: networkService)
        self.cartBookRepository = CartBookRepository(coreDataStorage: coreDataStorage)
        self.recentBookRepository = RecentBookRepository(coreDataStorage: coreDataStorage)

        self.cartBookUseCase = CartBookUseCase(cartBookRepository: cartBookRepository)
        self.recentBooksUseCase = RecentBooksUseCase(recentBookRepository: recentBookRepository)
        self.searchBooksUseCase = SearchBooksUseCase(bookRepository: bookRepository)
    }

    func makeMainViewController() -> MainViewController {
        let viewModel = MainViewModel(
            searchBooksUseCase: searchBooksUseCase,
            recentBooksUseCase: recentBooksUseCase
        )

        return MainViewController(viewModel: viewModel, diContainer: self)
    }

    func makeCartBookListViewController() -> CartBookListViewController {
        let viewModel = CartBookListViewModel(cartBookUseCase: cartBookUseCase)

        return CartBookListViewController(viewModel: viewModel)
    }

    func makeBookDetailViewController(book: Book) -> (BookDetailViewController, BookDetailViewModel) {
        let viewModel = BookDetailViewModel(
            book: book,
            cartBookUseCase: cartBookUseCase,
            recentBookUseCase: recentBooksUseCase
        )

        let viewController = BookDetailViewController(bookDetailViewModel: viewModel)

        return (viewController, viewModel)
    }
}
