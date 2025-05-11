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
        let repository = BookRepositoryImpl(service: BookAPIService())
        let useCase = DefaultSearchBooksUseCase(repository: repository)
        let viewModel = SearchViewModel(searchBooksUseCase: useCase)
        return SearchViewController(viewModel: viewModel)
    }
}

