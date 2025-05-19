//
//  CartBookUseCase.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation

protocol CartBookUseCaseProtocol: AnyObject {
    func save(book: Book) throws
    func fetchCartBooks() throws -> [CartBook]
    func deleteAllCartBooks() throws
    func deleteCartBook(cartBook: CartBook) throws
}

final class CartBookUseCase: CartBookUseCaseProtocol {
    private let cartBookRepository: CartBookRepositoryProtocol

    init(cartBookRepository: CartBookRepositoryProtocol) {
        self.cartBookRepository = cartBookRepository
    }

    func save(book: Book) throws {
        try cartBookRepository.addCartBook(book: book)
    }

    func fetchCartBooks() throws -> [CartBook] {
        try cartBookRepository.fetchCartBooks()
    }

    func deleteAllCartBooks() throws {
        try cartBookRepository.deleteAllCartBooks()
    }

    func deleteCartBook(cartBook: CartBook) throws {
        try cartBookRepository.deleteCartBook(createdAt: cartBook.createdAt)
    }
}
