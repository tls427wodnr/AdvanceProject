//
//  SearchDIContainer.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

// MARK: - SearchDIContainer

final class SearchDIContainer {
    
    // MARK: - Dependencies

    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initializer

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Dependency Injection

    func makeSearchViewModel() -> SearchViewModelProtocol {
        let repository = BookRepository(networkService: networkService)
        let useCase = FetchBooksUseCase(repository: repository)
        return SearchViewModel(fetchBooksUseCase: useCase)
    }
}
