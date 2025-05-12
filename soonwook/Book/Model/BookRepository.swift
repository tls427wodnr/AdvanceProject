//
//  BookRepository.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation

protocol BookRepositoryProtocol {
    func searchBook(searchText: String, completion: @escaping (Result<[Book], Error>) -> Void)
}

final class BookRepository: BookRepositoryProtocol {
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // API 호출하여 책 검색
    func searchBook(searchText: String, completion: @escaping (Result<[Book], Error>) -> Void) {
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
}
