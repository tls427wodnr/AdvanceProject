//
//  SearchFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class SearchFactory {
    func makeSearchViewController(coordinator: SearchCoordinator) -> SearchViewController {
        return SearchViewController()
    }
}
