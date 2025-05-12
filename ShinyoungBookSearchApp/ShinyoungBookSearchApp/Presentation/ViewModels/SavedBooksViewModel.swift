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
    
    let savedBooksSubject = BehaviorSubject(value: [Book]())
    let deleteAllBooksSubject = BehaviorSubject(value: false)
    let deletebookSubject = PublishSubject<Int>()
    
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
                self?.deleteAllBooksSubject.onNext(true)
            }, onFailure: { [weak self] error in
                self?.deleteAllBooksSubject.onError(error)
            }).disposed(by: disposeBag)
    }
    
    func deleteBook(index: Int, title: String) {
        CoreDataService.shared.deleteBook(title: title)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.deletebookSubject.onNext(index)
            }).disposed(by: disposeBag)
    }
}
