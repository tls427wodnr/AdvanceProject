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
    
    private var currentPage = 1
    private var isEnd = false
    
    var hasNextPage: Bool {
        return !isEnd
    }
    
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    var isLoadingDriver: Driver<Bool> {
        isLoadingRelay.asDriver()
    }
    
    var isLoading: Bool {
        return isLoadingRelay.value
    }
    
    func searchBooks(with query: String, isPaging: Bool = false) {
        isLoadingRelay.accept(true)
        
        var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(currentPage)")
        ]
        
        guard let url = components?.url else {
            bookSearchResultsSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkService.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: BookSearchResponse) in
                guard let self else { return }
                
                self.isEnd = response.meta?.isEnd ?? true
                
                let books = response.documents.map { $0.toDomain() }
                if isPaging {
                    let current = (try? self.bookSearchResultsSubject.value()) ?? []
                    self.bookSearchResultsSubject.onNext(current + books)
                } else {
                    self.currentPage = 1
                    self.bookSearchResultsSubject.onNext(books)
                }
                self.currentPage += 1
                self.isLoadingRelay.accept(false)
            }, onFailure: { [weak self] error in
                self?.bookSearchResultsSubject.onError(error)
                self?.isLoadingRelay.accept(false)
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
