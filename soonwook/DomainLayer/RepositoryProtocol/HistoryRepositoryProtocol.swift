//
//  HistoryRepositoryProtocol.swift
//  Book
//
//  Created by 권순욱 on 5/15/25.
//

import Foundation

public protocol HistoryRepositoryProtocol {
    func recordHistory(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String)
    func fetchHistories() -> [(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String, timestamp: Date)]
    func deleteHistory()
    func isHistoryExist(isbn: String) -> Bool
    func updateHistory(isbn: String)
}
