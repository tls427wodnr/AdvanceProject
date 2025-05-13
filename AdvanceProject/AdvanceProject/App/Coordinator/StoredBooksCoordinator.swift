//
//  StoredBooksCoordinator.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class StoredBooksCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let factory: StoredBooksFactory
    private(set) weak var parentCoordinator: TabbarCoordinator?
    private var currentCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        factory: StoredBooksFactory,
        parent: TabbarCoordinator
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.parentCoordinator = parent
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }
    
    func start() {
        let vc = factory.makeStoredBooksViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
}
