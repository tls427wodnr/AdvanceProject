//
//  AppCoordinator.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import UIKit

final class AppCoordinator {

    private let window: UIWindow
    private let container: AppDIContainer

    init(window: UIWindow, container: AppDIContainer) {
        self.window = window
        self.container = container
    }

    func start() {
        let tabBarController = MainTabBarController()

        let searchVM = container.makeSearchViewModel()
        let recentBookListVM = container.makeRecentBookListViewModel()
        let searchVC = SearchViewController(searchViewModel: searchVM, recentViewModel: recentBookListVM)
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let bookListVM = container.makeBookListViewModel()
        let bookListVC = BookListViewController(viewModel: bookListVM)
        let bookNav = UINavigationController(rootViewController: bookListVC)
        bookNav.tabBarItem = UITabBarItem(title: "담은 책 리스트", image: UIImage(systemName: "books.vertical"), tag: 1)

        tabBarController.setViewControllers([searchNav, bookNav], animated: false)

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
