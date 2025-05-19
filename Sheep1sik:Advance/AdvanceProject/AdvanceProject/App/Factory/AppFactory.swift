//
//  AppFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class AppFactory {
    
    func makeTabbarCoordinator(coordinator: AppCoordinator) -> TabbarCoordinator {
        let tabbarFactory = TabbarFactory()
        return TabbarCoordinator(factory: tabbarFactory, parent: coordinator)
    }
}
