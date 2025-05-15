//
//  AppDIContainer.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

// MARK: - AppDIContainer

final class AppDIContainer {

    // MARK: - Dependencies
    
    private let networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - DIContainers
    
    func makeSearchDIContainer() -> SearchDIContainer {
        return SearchDIContainer(networkService: networkService)
    }

    func makeBookListDIContainer() -> BookListDIContainer {
        return BookListDIContainer()
    }

    func makeBookDetailDIContainer() -> BookDetailDIContainer {
        return BookDetailDIContainer()
    }

    func makeRecentBookDIContainer() -> RecentBookDIContainer {
        return RecentBookDIContainer()
    }
}
