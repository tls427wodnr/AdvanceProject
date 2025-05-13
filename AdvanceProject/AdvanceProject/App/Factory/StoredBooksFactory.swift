//
//  StoredBooksFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

final class StoredBooksFactory {
    func makeStoredBooksViewController(coordinator: StoredBooksCoordinator) -> StoredBooksViewController {
        let repository = StoredBooksRepositoryImpl()
        let useCase = DefaultStoredBooksUseCase(repository: repository)
        let viewModel = StoredBooksViewModel(useCase: useCase)
        return StoredBooksViewController(viewModel: viewModel, coordinator: coordinator)
    }
}
