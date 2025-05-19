//
//  TabBarController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit
import DomainLayer

public class TabBarController: UITabBarController {
    let searchBookUseCase: SearchBookUseCaseProtocol
    let cartItemUseCase: CartItemUseCaseProtocol
    let recentBookUseCase: RecentBookUseCaseProtocol
    
    public init(searchBookUseCase: SearchBookUseCaseProtocol, cartItemUseCase: CartItemUseCaseProtocol, recentBookUseCase: RecentBookUseCaseProtocol) {
        self.searchBookUseCase = searchBookUseCase
        self.cartItemUseCase = cartItemUseCase
        self.recentBookUseCase = recentBookUseCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchViewModel = SearchViewModel(searchBookUseCase: searchBookUseCase, cartItemUseCase: cartItemUseCase, recentBookUseCase: recentBookUseCase)
        let searchViewController = UINavigationController(rootViewController: SearchViewController(viewModel: searchViewModel))
        searchViewController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let cartViewModel = CartViewModel(cartItemUseCase: cartItemUseCase)
        let cartViewController = UINavigationController(rootViewController: CartViewController(viewModel: cartViewModel))
        cartViewController.tabBarItem = UITabBarItem(title: "장바구니", image: UIImage(systemName: "cart"), tag: 1)
        
        viewControllers = [searchViewController, cartViewController]
        
        tabBar.isTranslucent = false
    }
}
