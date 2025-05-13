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
    
    let isSavedRecentBookSubject = BehaviorSubject<Bool>(value: false)
    
    let favoriteBookSaved = PublishSubject<Void>()
    let favoriteBookSaveFailed = PublishSubject<Error>()
    
    func saveFavoriteBook(with book: Book) {
        CoreDataService.shared.saveFavorite(book: book)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] in
                    self?.favoriteBookSaved.onNext(())
                },
                onFailure: { [weak self] error in
                    print("CoreData 저장 실패: \(error)")
                    self?.favoriteBookSaveFailed.onNext(error)
                }
            ).disposed(by: disposeBag)
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
