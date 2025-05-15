//
//  Book.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation

struct Book: Decodable {
    let isbn: String // id로 사용
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
