//
//  SearchCoordinator.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import UIKit

// MARK: - SearchCoordinator

final class SearchCoordinator {
    
    // MARK: - Properties

    private let navigationController: UINavigationController
    private let container: AppDIContainer
    
    // MARK: - Initializer

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    // MARK: - Start

    func start() {
        let searchVM = container.makeSearchDIContainer().makeSearchViewModel()
        let recentVM = container.makeRecentBookDIContainer().makeRecentBookListViewModel()
        let searchVC = SearchViewController(searchViewModel: searchVM, recentViewModel: recentVM)
        searchVC.delegate = self
        navigationController.setViewControllers([searchVC], animated: false)
    }
}

// MARK: - SearchViewControllerDelegate

extension SearchCoordinator: SearchViewControllerDelegate {
    func searchViewController(_ viewController: UIViewController, didSelect book: BookItem) {
        let viewModel = container.makeBookDetailDIContainer().makeBookDetailViewModel(book: book)
        let bottomSheetVC = BookDetailBottomSheetViewController(viewModel: viewModel)
        bottomSheetVC.modalPresentationStyle = .pageSheet
        bottomSheetVC.configure(with: book)

        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }

        viewController.present(bottomSheetVC, animated: true)
    }
}
