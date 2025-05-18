//
//  NetworkService.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol {
    func fetchSearchResult(query: String, page: Int) -> Single<SearchResultResponse>
}

final class NetworkService: NetworkServiceProtocol {
    func fetchSearchResult(query: String, page: Int) -> Single<SearchResultResponse> {
        return Single.create { single in
            var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")
            components?.queryItems = [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page))
            ]

            print(components?.url)

            guard let url = components?.url else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }

            var request = URLRequest(url: url)
            request.addValue("KakaoAK \(API_KEY)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    single(.failure(error))
                    return
                }

                guard let data else {
                    single(.failure(NetworkError.noData))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    print(result)
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
