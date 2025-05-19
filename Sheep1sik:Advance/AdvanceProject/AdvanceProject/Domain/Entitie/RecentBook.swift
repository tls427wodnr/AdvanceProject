//
//  RecentBook.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

import Foundation

struct RecentBook {
    let title: String
    let thumbnail: String
    let authors: [String]
    let contents: String
    let publisher: String
    let url: String
    let price: Int
    let isbn: String
    let createdAt: Date?
}
extension RecentBook {
    func toBook() -> Book {
        return Book(
            title: title,
            thumbnail: thumbnail,
            authors: authors,
            contents: contents,
            publisher: publisher,
            url: url,
            price: price,
            isbn: isbn
        )
    }
}
