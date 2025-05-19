//
//  Book.swift
//  Book
//
//  Created by 권순욱 on 5/15/25.
//

import Foundation

public struct Book: Decodable {
    public let isbn: String // id로 사용
    public let title: String
    public let authors: [String]
    public let price: Int
    public let contents: String
    public let thumbnail: String
    public let timestamp: Date?
    
    public init(isbn: String, title: String, authors: [String], price: Int, contents: String, thumbnail: String, timestamp: Date? = nil) {
        self.isbn = isbn
        self.title = title
        self.authors = authors
        self.price = price
        self.contents = contents
        self.thumbnail = thumbnail
        self.timestamp = timestamp
    }
}

extension Book {
    public var author: String {
        authors.isEmpty ? "" : authors[0]
    }
}
