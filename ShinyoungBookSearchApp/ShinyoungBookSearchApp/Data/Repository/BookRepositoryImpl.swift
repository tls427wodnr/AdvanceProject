//
//  BookRepositoryImpl.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/18/25.
//

import Foundation
import RxSwift

final class BookRepositoryImpl: BookRepository {
    func searchBooks(query: String, page: Int) -> Single<BookSearchResponse> {
        var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let url = components?.url else {
            return .error(NetworkError.invalidURL)
        }
        
        return NetworkService.shared.fetch(url: url)
    }
}
