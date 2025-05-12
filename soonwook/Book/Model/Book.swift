//
//  Book.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation

struct BookResponse: Decodable {
    let documents: [Book]
}

struct Book: Decodable {
    let title: String
    let authors: [String]
    let price: Int
    let contents: String
    let thumbnail: String
}

extension Book {
    var author: String {
        authors.isEmpty ? "" : authors[0]
    }
}
