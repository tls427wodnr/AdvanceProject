//
//  TabBarController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class TabBarController: UITabBarController {
    let bookRepository: BookRepositoryProtocol
    let cartRepository: CartRepositoryProtocol
    
    init(bookRepository: BookRepositoryProtocol, cartRepository: CartRepositoryProtocol) {
        self.bookRepository = bookRepository
        self.cartRepository = cartRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchViewModel = SearchViewModel(bookRepository: bookRepository, cartRepository: cartRepository)
        let searchViewController = UINavigationController(rootViewController: SearchViewController(viewModel: searchViewModel))
        searchViewController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let cartViewModel = CartViewModel(cartRepository: cartRepository)
        let cartViewController = UINavigationController(rootViewController: CartViewController(viewModel: cartViewModel))
        cartViewController.tabBarItem = UITabBarItem(title: "장바구니", image: UIImage(systemName: "cart"), tag: 1)
        
        viewControllers = [searchViewController, cartViewController]
        
        tabBar.isTranslucent = false
    }
}
