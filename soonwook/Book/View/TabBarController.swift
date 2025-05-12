//
//  TabBarController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        searchViewController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let cartViewController = UINavigationController(rootViewController: CartViewController())
        cartViewController.tabBarItem = UITabBarItem(title: "장바구니", image: UIImage(systemName: "cart"), tag: 1)
        
        viewControllers = [searchViewController, cartViewController]
        
        tabBar.isTranslucent = false
    }
}
