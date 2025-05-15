//
//  BookListViewModel.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Input

struct BookListViewModelInput {
    let loadTrigger: Observable<Void>
    let deleteTrigger: Observable<String>
    let deleteAllTrigger: Observable<Void>
}

// MARK: - Output

struct BookListViewModelOutput {
    let books: Driver<[BookItem]>
    let error: Driver<String>
}

// MARK: - Protocol

protocol BookListViewModelProtocol {
    func transform(input: BookListViewModelInput) -> BookListViewModelOutput
}

// MARK: - ViewModel

final class BookListViewModel: BookListViewModelProtocol {

    // MARK: - Properties

    private let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    private let errorRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    private let useCase: LocalBookUseCaseProtocol

    // MARK: - Initializer

    init(useCase: LocalBookUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Transform

    func transform(input: BookListViewModelInput) -> BookListViewModelOutput {

        input.loadTrigger
            .flatMapLatest { [unowned self] in
                useCase.fetchAll()
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let books):
                    self?.booksRelay.accept(books)
                case .error(let error):
                    self?.errorRelay.accept(error.localizedDescription)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        input.deleteTrigger
            .flatMapLatest { [unowned self] isbn in
                useCase.delete(isbn: isbn)
                    .andThen(useCase.fetchAll())
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let books):
                    self?.booksRelay.accept(books)
                case .error(let error):
                    self?.errorRelay.accept(error.localizedDescription)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        input.deleteAllTrigger
            .flatMapLatest { [unowned self] in
                useCase.deleteAll()
                    .andThen(useCase.fetchAll())
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .next(let books):
                    self?.booksRelay.accept(books)
                case .error(let error):
                    self?.errorRelay.accept(error.localizedDescription)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        return BookListViewModelOutput(
            books: booksRelay.asDriver(),
            error: errorRelay.asDriver(onErrorJustReturn: "알 수 없는 오류")
        )
    }
}
