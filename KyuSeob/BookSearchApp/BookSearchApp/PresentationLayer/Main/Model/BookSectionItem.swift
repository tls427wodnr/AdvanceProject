//
//  BookSectionItem.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/15/25.
//

import Foundation
import Differentiator

enum BookSectionItem {
    case recent(RecentBook)
    case search(Book)
}

extension BookSectionItem: IdentifiableType, Equatable {
    var identity: String {
        switch self {
        case .recent(let book):
            return "recent-\(book.book.isbn)-\(book.lastViewedAt.timeIntervalSince1970)"
        case .search(let book):
            return "search-\(book.isbn)"
        }
    }

    static func == (lhs: BookSectionItem, rhs: BookSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
