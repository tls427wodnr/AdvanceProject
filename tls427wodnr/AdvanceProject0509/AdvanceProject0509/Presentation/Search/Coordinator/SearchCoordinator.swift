//
//  SearchCoordinator.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import UIKit

final class SearchCoordinator {
    private let navigationController: UINavigationController
    private let container: AppDIContainer

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let searchVM = container.makeSearchViewModel()
        let recentVM = container.makeRecentBookListViewModel()
        let searchVC = SearchViewController(searchViewModel: searchVM, recentViewModel: recentVM)
        searchVC.delegate = self
        navigationController.setViewControllers([searchVC], animated: false)
    }
}

extension SearchCoordinator: SearchViewControllerDelegate {
    func searchViewController(_ viewController: UIViewController, didSelect book: BookItem) {
        let viewModel = container.makeBookDetailViewModel(book: book)
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
