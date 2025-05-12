//
//  SearchCoordinator.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let factory: SearchFactory
    private(set) weak var parentCoordinator: TabbarCoordinator?
    private var currentCoordinators: [Coordinator] = []
    
    init(
        navigationController: UINavigationController,
        factory: SearchFactory,
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
        let vc = factory.makeSearchViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    
}
