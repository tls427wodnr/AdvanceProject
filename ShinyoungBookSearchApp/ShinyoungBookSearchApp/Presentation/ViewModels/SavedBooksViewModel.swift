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
    
    func fetchSavedBooks() {
        CoreDataService.shared.fetchSavedBooks()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] books in
                self?.savedBooksSubject.onNext(books)
            }, onFailure: { [weak self] error in
                self?.savedBooksSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
