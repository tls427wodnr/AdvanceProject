//
//  BookListViewModel.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BookListViewModel {

    // MARK: - Input

    struct Input {
        let loadTrigger: Observable<Void>
        let deleteTrigger: Observable<String>
        let deleteAllTrigger: Observable<Void>
    }

    // MARK: - Output

    struct Output {
        let books: Driver<[BookItem]>
        let error: Driver<String>
    }

    // MARK: - Private

    private let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    private let errorRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    private let coreDataManager: BookDataManager

    // MARK: - Init

    init(coreDataManager: BookDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {

        input.loadTrigger
            .flatMapLatest { [unowned self] in
                coreDataManager.fetchBooks()
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
                coreDataManager.deleteBook(byISBN: isbn)
                    .andThen(coreDataManager.fetchBooks())
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
                coreDataManager.deleteBooks()
                    .andThen(coreDataManager.fetchBooks())
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

        return Output(
            books: booksRelay.asDriver(),
            error: errorRelay.asDriver(onErrorJustReturn: "알 수 없는 오류")
        )
    }
}
