//
//  RecentBookRepositoryProtocol.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/14/25.
//

import Foundation

protocol RecentBookRepositoryProtocol: AnyObject {
    func fetchSortedRecentBookEntities(toPresent: Bool) throws -> [RecentBookEntity] // 최근 본 책 불러오기
    func fetchSortedRecentBooks() throws -> [RecentBook]
    func addAndFetchRecentBookList(book: Book) throws // 최근 본 책 추가
}
