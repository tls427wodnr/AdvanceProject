//
//  NetworkService.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation
import RxSwift

public protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData<T: Decodable>(with request: URLRequest) -> Single<T>
}

enum NetworkError: Error {
    case noData
    case responseFailed
    case parsingFailed
    case wrongURL
}

public final class NetworkService: NetworkServiceProtocol {
    public init() {}
    
    public func fetchData<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            let successRange = 200..<300
            guard let response = response as? HTTPURLResponse,
                  successRange.contains(response.statusCode)
            else {
                completion(.failure(NetworkError.responseFailed))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.parsingFailed))
            }
        }
        
        task.resume()
    }
    
    public func fetchData<T: Decodable>(with request: URLRequest) -> Single<T> {
        return Single<T>.create { observer in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    observer(.failure(error))
                    return
                }
                
                let successRange = 200..<300
                guard let response = response as? HTTPURLResponse,
                      successRange.contains(response.statusCode)
                else {
                    observer(.failure(NetworkError.responseFailed))
                    return
                }
                
                guard let data else {
                    observer(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(response))
                } catch {
                    observer(.failure(NetworkError.parsingFailed))
                }
            }
            
            task.resume()
            
            return Disposables.create()
        }
    }
}
