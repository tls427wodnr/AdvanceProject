//
//  MainTabBarController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let diContainer = DIContainer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .init(hex: "999999")

        let firstVC = diContainer.makeMainViewController()
        firstVC.tabBarItem = UITabBarItem(title: "검색", image: .init(systemName: "magnifyingglass"), tag: 0)

        let secondVC = diContainer.makeCartBookListViewController()
        secondVC.tabBarItem = UITabBarItem(title: "담은 책", image: .init(systemName: "list.bullet"), tag: 1)

        viewControllers = [
            UINavigationController(rootViewController: firstVC),
            UINavigationController(rootViewController: secondVC)
        ]
    }
}
