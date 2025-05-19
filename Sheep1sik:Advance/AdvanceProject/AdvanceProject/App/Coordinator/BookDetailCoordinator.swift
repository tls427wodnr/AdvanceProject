//
//  BookDetailCoordinator.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit

final class BookDetailCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let factory: BookDetailFactory
    private let book: Book

    init(
        navigationController: UINavigationController,
        factory: BookDetailFactory,
        book: Book
    ) {
        self.navigationController = navigationController
        self.factory = factory
        self.book = book
    }

    func start() {
        let viewController = factory.makeBookDetailViewController(book: book, coordinator: self)
        let nav = UINavigationController(rootViewController: viewController)
        navigationController.present(nav, animated: true)
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
