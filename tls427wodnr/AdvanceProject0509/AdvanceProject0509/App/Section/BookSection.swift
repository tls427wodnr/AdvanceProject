//
//  BookSection.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import RxDataSources

// MARK: - BookSection

enum BookSection {
    case recent([BookItem])
    case search([BookItem])
}

// MARK: - SectionModelType

extension BookSection: SectionModelType {
    typealias Item = BookItem

    var items: [BookItem] {
        switch self {
        case .recent(let books): return books
        case .search(let books): return books
        }
    }

    init(original: BookSection, items: [BookItem]) {
        switch original {
        case .recent: self = .recent(items)
        case .search: self = .search(items)
        }
    }
}
