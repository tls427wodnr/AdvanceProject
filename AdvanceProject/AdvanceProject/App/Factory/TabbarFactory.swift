//
//  TabbarFactory.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import Foundation

final class TabbarFactory {

    func makeSearchFactory() -> SearchFactory {
        return SearchFactory()
    }

    func makeStoredBooksFactory() -> StoredBooksFactory {
        return StoredBooksFactory()
    }
}
