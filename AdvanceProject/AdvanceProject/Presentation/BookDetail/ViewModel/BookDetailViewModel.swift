//
//  BookDetailViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//
import RxSwift

final class BookDetailViewModel {
    let book: Book
    private weak var coordinator: BookDetailCoordinator?

    init(book: Book, coordinator: BookDetailCoordinator?) {
        self.book = book
        self.coordinator = coordinator
    }

    func didTapClose() {
        coordinator?.dismiss()
    }

    func tryAddBook() -> Observable<Bool> {
        return Observable.create { observer in
            if CoreDataManager.shared.isBookAlreadyStored(self.book) {
                observer.onNext(false)
            } else {
                CoreDataManager.shared.save(book: self.book)
                observer.onNext(true)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }

    func didTapAddBook() {
        coordinator?.dismiss()
    }
}

