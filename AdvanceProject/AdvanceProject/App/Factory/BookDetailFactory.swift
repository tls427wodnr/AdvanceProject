//
//  BookDetailFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit

protocol BookDetailFactory {
    func makeBookDetailViewController(book: Book, coordinator: BookDetailCoordinator) -> BookDetailViewController
}

final class DefaultBookDetailFactory: BookDetailFactory {
    func makeBookDetailViewController(book: Book, coordinator: BookDetailCoordinator) -> BookDetailViewController {
        let viewModel = BookDetailViewModel(book: book, coordinator: coordinator)
        let viewController = BookDetailViewController(viewModel: viewModel)
        return viewController
    }
}
