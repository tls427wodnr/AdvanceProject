//
//  StoredBooksFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class StoredBooksFactory {
    func makeStoredBooksViewController(coordinator: StoredBooksCoordinator) -> StoredBooksViewController {
        return StoredBooksViewController()
    }
}
