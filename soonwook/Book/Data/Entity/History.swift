//
//  History.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation

struct History {
    let isbn: String
    let title: String
    let authors: [String]
    let price: Int
    let contents: String
    let thumbnail: String
    let timestamp: Date
}

extension History {
    var author: String {
        authors.isEmpty ? "" : authors[0]
    }
}
