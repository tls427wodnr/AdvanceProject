//
//  NetworkManager.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import Foundation
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    init() {}
    
    func fetchBooksAPI(query: String, start: Int) -> Observable<[BookItem]> {
        return Observable.create { observer in
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let urlString = "https://openapi.naver.com/v1/search/book.json?query=\(encodedQuery)&display=30&start=\(start)"
            let clientID = AppConfig.clientID
            let clientSecret = AppConfig.clientSecret
            
            guard let url = URL(string: urlString) else {
                observer.onError(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(NSError(domain: "Invalid response", code: -2, userInfo: nil))
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "No data", code: -3, userInfo: nil))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(BookResponse.self, from: data)
                    observer.onNext(decoded.items)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create { task.cancel() }
        }
    }
}
