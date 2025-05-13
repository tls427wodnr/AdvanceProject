//
//  BookSearchViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/10/25.
//

import Foundation
import RxSwift

final class BookSearchViewModel {
    private let disposeBag = DisposeBag()
    
    let bookSearchResultsSubject = BehaviorSubject(value: [Book]())
    let recentBooksSubject = BehaviorSubject(value: [Book]())
    
    private let networkService = NetworkService.shared
    
    func searchBooks(with query: String) {
        var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        guard let url = components?.url else {
            bookSearchResultsSubject.onError(NetworkError.invalidURL)
            return
        }
        
        networkService.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: BookSearchResponse) in
                let books = response.documents.map { $0.toDomain() }
                self?.bookSearchResultsSubject.onNext(books)
            }, onFailure: { [weak self] error in
                self?.bookSearchResultsSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func fetchRecentBooks() {
        CoreDataService.shared.fetchRecentBooks()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] books in
                self?.recentBooksSubject.onNext(books)
            }, onFailure: { [weak self] error in
                self?.recentBooksSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
