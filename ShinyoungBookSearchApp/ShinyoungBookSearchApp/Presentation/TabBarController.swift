//
//  TabBarController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol ScrollToTopCapable {
    func scrollToTop()
}

final class TabBarController: UITabBarController {
    private let disposeBag = DisposeBag()
    private let tabReselected = PublishRelay<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
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
        
        tabReselected
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                if let vc = owner.viewControllers?[index] as? ScrollToTopCapable {
                    vc.scrollToTop()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = tabBarController.viewControllers,
              let index = viewControllers.firstIndex(of: viewController)
        else { return true }

        if viewController == tabBarController.selectedViewController {
            tabReselected.accept(index)
        }
        return true
    }
}
