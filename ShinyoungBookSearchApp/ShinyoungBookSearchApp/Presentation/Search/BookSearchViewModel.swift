//
//  BookSearchViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BookSearchViewModel {
    private let disposeBag = DisposeBag()
    
    let metaSubject = PublishSubject<Meta>()
    let bookSearchResultsSubject = BehaviorSubject<[Book]>(value: [])
    let recentBooksSubject = BehaviorSubject<[Book]>(value: [])
    
    var metaDriver: Driver<Meta> {
        metaSubject.asDriver(onErrorDriveWith: .empty())
    }
    
    var sectionedBooksDriver: Driver<[BookSectionModel]> {
        Observable.combineLatest(recentBooksSubject, bookSearchResultsSubject)
            .map { recent, search in
                return [
                    BookSectionModel(type: .recent, header: "최근 본 책", items: recent),
                    BookSectionModel(type: .searchResult, header: "검색 결과", items: search)
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func searchBooks(with query: String) {
        var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        guard let url = components?.url else {
            bookSearchResultsSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkService.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: BookSearchResponse) in
                let books = response.documents.map { $0.toDomain() }
                self?.bookSearchResultsSubject.onNext(books)
                
                if let meta = response.meta {
                    self?.metaSubject.onNext(meta)
                }                
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
