//
//  SavedBooksViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import Foundation
import RxSwift

final class SavedBooksViewModel {
    private let disposeBag = DisposeBag()
    
    let savedBooksSubject = BehaviorSubject<[Book]>(value: [])
    let deleteAllBooksSubject = PublishSubject<Void>()
    
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
                self?.deleteAllBooksSubject.onNext(())
                self?.fetchSavedBooks()
            }, onFailure: { [weak self] error in
                self?.deleteAllBooksSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func deleteBook(title: String) {
        CoreDataService.shared.deleteBook(title: title)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.fetchSavedBooks()
            }).disposed(by: disposeBag)
    }
}
