//
//  BookListCoordinator.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import UIKit

// MARK: - BookListCoordinator

final class BookListCoordinator {
    
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
        let viewModel = container.makeBookListDIContainer().makeBookListViewModel()
        let viewController = BookListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
