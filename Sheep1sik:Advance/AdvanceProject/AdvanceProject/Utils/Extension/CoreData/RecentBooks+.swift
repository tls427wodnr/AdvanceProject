//
//  Untitled.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

import Foundation

extension RecentBooks {
    func toRecentBook() -> RecentBook {
        return RecentBook(
            title: self.title ?? "",
            thumbnail: self.thumbnail ?? "",
            authors: (self.authors ?? "").components(separatedBy: ", "),
            contents: self.contents ?? "",
            publisher: self.publisher ?? "",
            url: self.url ?? "",
            price: Int(self.price),
            isbn: self.isbn ?? "",
            createdAt: self.createdAt
        )
    }
    
    func toBook() -> Book {
        return Book(
            title: self.title ?? "",
            thumbnail: self.thumbnail ?? "",
            authors: (self.authors ?? "").components(separatedBy: ", "),
            contents: self.contents ?? "",
            publisher: self.publisher ?? "",
            url: self.url ?? "",
            price: Int(self.price),
            isbn: self.isbn ?? ""
        )
    }
}
