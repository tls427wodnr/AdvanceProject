//
//  BookRepository.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import Foundation
import RxSwift

// MARK: - BookRepository

final class BookRepository: BookRepositoryProtocol {
    
    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    private let baseURL = "https://openapi.naver.com/v1/search/book.json"
    
    // MARK: - Initializer

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Methods

    func fetchBooks(query: String, start: Int) -> Observable<[BookItem]> {
        guard var components = URLComponents(string: baseURL) else {
            return Observable.error(NSError(domain: "Invalid base URL", code: -1))
        }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        
        guard let url = components.url else {
            return Observable.error(NSError(domain: "Invalid query", code: -1))
        }
        
        let headers = [
            "X-Naver-Client-Id": AppConfig.clientID,
            "X-Naver-Client-Secret": AppConfig.clientSecret
        ]
        
        return networkService.request(BookResponse.self, url: url, headers: headers)
            .map { $0.items }
    }
}
