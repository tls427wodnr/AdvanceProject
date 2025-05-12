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
    
    func didTapAddBook() {
        CoreDataManager.shared.save(book: book)
        coordinator?.didAddBookToLibrary(book)
    }

    func tryAddBook() -> Observable<Bool> {
        return Observable.create { observer in
            if CoreDataManager.shared.isBookAlreadyStored(self.book) {
                observer.onNext(false) // 이미 저장됨
            } else {
                CoreDataManager.shared.save(book: self.book)
                observer.onNext(true) // 새로 저장함
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }

}
