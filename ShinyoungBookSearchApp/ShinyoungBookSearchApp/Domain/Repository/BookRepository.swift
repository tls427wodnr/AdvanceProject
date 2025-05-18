//
//  BookRepository.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/18/25.
//

import RxSwift

protocol BookRepository {
    func searchBooks(query: String, page: Int) -> Single<BookSearchResponse>
}
