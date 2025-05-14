//
//  ViewController.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        let bookListVC = UINavigationController(rootViewController: BookListViewController())
        bookListVC.tabBarItem = UITabBarItem(title: "담은 책 리스트", image: UIImage(systemName: "books.vertical"), tag: 1)

        viewControllers = [searchVC, bookListVC]
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        appearance.shadowImage = nil
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }

}

