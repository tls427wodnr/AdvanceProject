//
//  BookDetailCoordinator.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit

final class BookDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let factory: BookDetailFactory
    private var childCoordinators: [Coordinator] = []

    private var book: Book

    init(navigationController: UINavigationController, factory: BookDetailFactory, book: Book) {
        self.navigationController = navigationController
        self.factory = factory
        self.book = book
    }

    func start() {
        let viewController = factory.makeBookDetailViewController(book: book, coordinator: self)
        let nav = UINavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .pageSheet
        navigationController.present(nav, animated: true)
    }

    func dismiss() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
    
    func didAddBookToLibrary(_ book: Book) {
        print("'\(book.title)' 장바구니에 담김")
        dismiss()
    }

}
