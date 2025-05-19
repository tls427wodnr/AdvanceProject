//
//  RecentBookDIContainer.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/15/25.
//

// MARK: - RecentBookDIContainer

final class RecentBookDIContainer {

    // MARK: - Dependency Injection

    func makeRecentBookListViewModel() -> RecentBookListViewModel {
        let repository = LocalRecentBookRepository()
        let useCase = LocalRecentBookUseCase(repository: repository)
        return RecentBookListViewModel(useCase: useCase)
    }
}
