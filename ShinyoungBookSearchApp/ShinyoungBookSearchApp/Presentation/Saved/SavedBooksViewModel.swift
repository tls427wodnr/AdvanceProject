//
//  SavedBooksViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SavedBooksViewModel {
    private let disposeBag = DisposeBag()
    
    let savedBooksSubject = BehaviorSubject<[Book]>(value: [])
    
    var savedBooksDriver: Driver<[Book]> {
        savedBooksSubject.asDriver(onErrorJustReturn: [])
    }
    
    func fetchSavedBooks() {
        CoreDataService.shared.fetchFavoriteBooks()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] books in
                self?.savedBooksSubject.onNext(books)
            }, onFailure: { [weak self] error in
                self?.savedBooksSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func deleteAllBooks() {
        CoreDataService.shared.deleteAllBooks()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.fetchSavedBooks()
            }, onFailure: { [weak self] error in
                self?.savedBooksSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func deleteBook(isbn: String) {
        CoreDataService.shared.deleteBook(isbn: isbn)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.fetchSavedBooks()
            }).disposed(by: disposeBag)
    }
}
