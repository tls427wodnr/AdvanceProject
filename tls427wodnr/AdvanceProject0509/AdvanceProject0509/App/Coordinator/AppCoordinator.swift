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

    private var searchCoordinator: SearchCoordinator?
    private var bookListCoordinator: BookListCoordinator?

    init(window: UIWindow, container: AppDIContainer) {
        self.window = window
        self.container = container
    }

    func start() {
        let tabBarController = MainTabBarController()

        // MARK: - Search
        let searchNav = UINavigationController()
        let searchCoordinator = SearchCoordinator(navigationController: searchNav, container: container)
        searchCoordinator.start()
        self.searchCoordinator = searchCoordinator
        searchNav.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        // MARK: - BookList
        let bookNav = UINavigationController()
        let bookCoordinator = BookListCoordinator(navigationController: bookNav, container: container)
        bookCoordinator.start()
        self.bookListCoordinator = bookCoordinator
        bookNav.tabBarItem = UITabBarItem(title: "담은 책 리스트", image: UIImage(systemName: "books.vertical"), tag: 1)

        tabBarController.setViewControllers([searchNav, bookNav], animated: false)

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
