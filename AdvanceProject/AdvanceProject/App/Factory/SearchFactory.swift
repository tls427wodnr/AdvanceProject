//
//  SearchFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class SearchFactory {
    func makeSearchViewController(coordinator: SearchCoordinator) -> SearchViewController {
        let service = BookAPIService()
        let bookRepository = BookRepositoryImpl(service: service)
        let searchUseCase = DefaultSearchBooksUseCase(repository: bookRepository)

        let recentBooksRepository = RecentBooksRepositoryImpl()
        let recentBooksUseCase = DefaultRecentBooksUseCase(repository: recentBooksRepository)

        let viewModel = SearchViewModel(
            searchBooksUseCase: searchUseCase,
            recentBooksUseCase: recentBooksUseCase
        )

        return SearchViewController(viewModel: viewModel, coordinator: coordinator)
    }
}


