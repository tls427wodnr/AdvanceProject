//
//  RecentBookRepositoryProtocol.swift
//  Book
//
//  Created by 권순욱 on 5/15/25.
//

import Foundation

public protocol RecentBookRepositoryProtocol {
    func saveBook(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String)
    func fetchBook() -> [(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String, timestamp: Date)]
    func deleteBookIfNeeded()
    func isBookExist(isbn: String) -> Bool
    func updateBook(isbn: String)
}
