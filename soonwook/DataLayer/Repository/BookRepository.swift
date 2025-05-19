//
//  BookRepository.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation
import RxSwift
import DomainLayer

public final class BookRepository: BookRepositoryProtocol {
    public let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // 무한 스크롤 구현 전: book 데이터만 수신, page 쿼리 불가
    public func searchBook(searchText: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let APIKey = Bundle.main.infoDictionary?["APIKey"] as! String
        
        // URL Components
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dapi.kakao.com"
        components.path = "/v3/search/book"
        components.queryItems = [URLQueryItem(name: "query", value: searchText)]
        guard let url = components.url else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        
        // URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Authorization": "KakaoAK \(APIKey)"]
        request.httpBody = nil
        
        networkService.fetchData(with: request) { (result: Result<BookResponse, Error>) in
            switch result {
            case .success(let response):
                let books = response.documents
                completion(.success(books))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 무한 스크롤 구현 후: book 데이터와 meta 데이터 수신, page 쿼리 가능, RxSwift 이용
    public func searchBook(searchText: String, page: Int) -> Single<(books: [DomainLayer.Book], meta: DomainLayer.Meta)> {
        let APIKey = Bundle.main.infoDictionary?["APIKey"] as! String
        
        // URL Components
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dapi.kakao.com"
        components.path = "/v3/search/book"
        components.queryItems = [
            URLQueryItem(name: "query", value: searchText),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        return Single<(books: [DomainLayer.Book], meta: DomainLayer.Meta)>.create { [weak self] observer in
            guard let url = components.url else {
                observer(.failure(NetworkError.wrongURL))
                return Disposables.create()
            }
            
            // URL Request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = ["Authorization": "KakaoAK \(APIKey)"]
            request.httpBody = nil
            
            self?.networkService.fetchData(with: request) { (result: Result<BookResponse, Error>) in
                switch result {
                case .success(let response):
                    let books: [DomainLayer.Book] = response.documents
                    let meta: DomainLayer.Meta = response.meta
                    observer(.success((books: books, meta: meta)))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
}
