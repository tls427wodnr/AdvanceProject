//
//  TabBarController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bookSearchVC = BookSearchViewController()
        let savedBooksVC = SavedBooksViewController()
        
        bookSearchVC.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 0
        )
        
        savedBooksVC.tabBarItem = UITabBarItem(
            title: "담은 책",
            image: UIImage(systemName: "books.vertical"),
            tag: 1
        )
        
        viewControllers = [bookSearchVC, savedBooksVC]
    }


}

