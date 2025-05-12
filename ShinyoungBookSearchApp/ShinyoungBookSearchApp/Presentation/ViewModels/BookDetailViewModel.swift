//
//  BookDetailViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import Foundation
import RxSwift

final class BookDetailViewModel {
    private let disposeBag = DisposeBag()
    
    let isSavedFavoriteBookSubject = BehaviorSubject<Bool>(value: false)
    let isSavedRecentBookSubject = BehaviorSubject<Bool>(value: false)
    
    func saveFavoriteBook(with book: Book) {
        CoreDataService.shared.saveFavorite(book: book)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.isSavedFavoriteBookSubject.onNext(true)
            }, onFailure: { [weak self] error in
                print("CoreData 저장 실패: \(error)")
                self?.isSavedFavoriteBookSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
    
    func saveRecentBook(with book: Book) {
        CoreDataService.shared.saveRecent(book: book)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.isSavedRecentBookSubject.onNext(true)
            }, onFailure: { [weak self] error in
                print("CoreData 저장 실패: \(error)")
                self?.isSavedRecentBookSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
