//
//  CartBookRepositoryProtocol.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation

protocol CartBookRepositoryProtocol: AnyObject {
    func saveCartBook(book: Book) throws
    func fetchCartBooks() throws -> [CartBook]
    func deleteAllCartBooks() throws
    func deleteCartBook(createdAt: Date) throws
}
