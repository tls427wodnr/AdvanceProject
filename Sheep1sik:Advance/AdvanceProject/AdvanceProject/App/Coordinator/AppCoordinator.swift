//
//  AppCoordinator.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let factory: AppFactory
    private var currentCoordinators: [Coordinator] = []
    
    init(window: UIWindow, factory: AppFactory) {
        self.window = window
        self.factory = factory
    }
    
    deinit {
        print("\(String(describing: Self.self)) 메모리 해제")
    }
    
    func start() {
        showTabbar()
    }
    
    private func showTabbar() {
        let tabbarCoordinator = factory.makeTabbarCoordinator(coordinator: self)

        currentCoordinators = [tabbarCoordinator]
        tabbarCoordinator.start()

        window.rootViewController = tabbarCoordinator.tabbarController
        window.makeKeyAndVisible()
    }
}
