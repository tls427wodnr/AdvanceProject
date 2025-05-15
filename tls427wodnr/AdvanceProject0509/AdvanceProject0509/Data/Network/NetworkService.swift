//
//  NetworkService.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/14/25.
//

import Foundation
import RxSwift

// MARK: - Protocol

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ type: T.Type, url: URL, headers: [String: String]) -> Observable<T>
}

// MARK: - Service

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Methods

    func request<T: Decodable>(_ type: T.Type, url: URL, headers: [String: String]) -> Observable<T> {
        return Observable.create { observer in
            var request = URLRequest(url: url)
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
            
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
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decoded)
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
