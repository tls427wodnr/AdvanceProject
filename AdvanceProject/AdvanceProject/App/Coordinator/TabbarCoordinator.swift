//
//  TabbarCoordinator.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class TabbarCoordinator: Coordinator {
    
    let tabbarController = UITabBarController()
    private let factory: TabbarFactory
    
    private(set) weak var parentCoordinator: AppCoordinator?
    private var childCoordinators: [Coordinator] = []
    
    init(
        factory: TabbarFactory,
        parent: AppCoordinator
    ) {
        self.factory = factory
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }
    
    func start() {
        let homeNC = UINavigationController()
        let searchNC = UINavigationController()
        let storedBooksNC = UINavigationController()
        
        // 탭바 스타일 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabbarController.tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabbarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        // 선택된 탭 아이템 색상 (파란색)
        tabbarController.tabBar.tintColor = .systemBlue
        
        // 선택 안 된 아이템 색상 (검은색 또는 회색)
        tabbarController.tabBar.unselectedItemTintColor = .gray
        
        [homeNC, searchNC, storedBooksNC].forEach { NC in
            NC.navigationBar.tintColor = .white
            NC.navigationItem.backButtonTitle = ""
        }
        
        let homeCoordinator = HomeCoordinator(
            navigationController: homeNC,
            factory: factory.makeHomeFactory(),
            parent: self
        )
        
        let searchCoordinator = SearchCoordinator(
            navigationController: searchNC,
            factory: factory.makeSearchFactory(),
            parent: self
        )
        
        let storedBooksCoordinator = StoredBooksCoordinator(
            navigationController: storedBooksNC,
            factory: factory.makeStoredBooksFactory(),
            parent: self
        )
        
        homeCoordinator.start()
        searchCoordinator.start()
        storedBooksCoordinator.start()
        
        childCoordinators = [homeCoordinator, searchCoordinator, storedBooksCoordinator]
        tabbarController.setViewControllers([homeNC, searchNC, storedBooksNC], animated: false)
        
        homeNC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        searchNC.tabBarItem = UITabBarItem(
            title: "책 검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass.fill")
        )
        
        storedBooksNC.tabBarItem = UITabBarItem(
            title: "책 바구니",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        
    }
    
}
