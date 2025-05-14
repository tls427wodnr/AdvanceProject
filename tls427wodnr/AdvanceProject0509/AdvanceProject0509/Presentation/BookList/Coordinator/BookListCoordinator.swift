//
//  BookListCoordinator.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import UIKit

final class BookListCoordinator {
    private let navigationController: UINavigationController
    private let container: AppDIContainer

    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let viewModel = container.makeBookListViewModel()
        let viewController = BookListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
