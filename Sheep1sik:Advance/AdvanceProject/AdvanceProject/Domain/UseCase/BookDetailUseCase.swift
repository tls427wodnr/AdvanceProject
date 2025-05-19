//
//  BookDetailUseCase.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//


import RxSwift

enum AddBookResult {
    case added
    case duplicate
}

protocol BookDetailUseCase {
    func tryAdd(book: Book) -> Observable<AddBookResult>
}

final class DefaultBookDetailUseCase: BookDetailUseCase {
    private let repository: BookDetailRepository

    init(repository: BookDetailRepository) {
        self.repository = repository
    }

    func tryAdd(book: Book) -> Observable<AddBookResult> {
        return Observable.create { observer in
            if self.repository.isBookAlreadyStored(book) {
                observer.onNext(.duplicate)
            } else {
                self.repository.save(book: book)
                observer.onNext(.added)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
