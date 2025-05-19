//
//  BookSection.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/14/25.
//

import UIKit
import RxDataSources

enum BookSection {
    case recent([BookSectionItem])
    case search([BookSectionItem])
}

extension BookSection: SectionModelType {
    typealias Item = BookSectionItem

    init(original: BookSection, items: [BookSectionItem]) {
        switch original {
        case .recent:
            self = .recent(items)
        case .search:
            self = .search(items)
        }
    }

    var items: [BookSectionItem] {
        switch self {
        case .recent(let items): return items
        case .search(let items): return items
        }
    }

    var layoutSection: NSCollectionLayoutSection {
        switch self {
        case .recent: return Section.createRecentSection()
        case .search: return Section.createSearchSection()
        }
    }
}
