//
//  StoredBooks+.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation

extension StoredBooks {
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
