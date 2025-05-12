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
    
    let isSavedBookSubject = BehaviorSubject<Bool>(value: false)
    
    func saveBook(with book: Book) {
        CoreDataService.shared.save(book: book)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] in
                self?.isSavedBookSubject.onNext(true)
            }, onFailure: { [weak self] error in
                print("CoreData 저장 실패: \(error)")
                self?.isSavedBookSubject.onNext(false)
            }).disposed(by: disposeBag)
    }
}
