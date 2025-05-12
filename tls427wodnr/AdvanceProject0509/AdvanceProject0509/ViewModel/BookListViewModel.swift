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
        let addTrigger: Observable<BookItem>
        let deleteTrigger: Observable<String>
        let deleteAllTrigger: Observable<Void>
    }

    // MARK: - Output
    
    struct Output {
        let books: Driver<[BookItem]>
        let error: Driver<String>
    }

    // MARK: - Properties
    
    private let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    private let errorRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    private let coreDataManager: CoreDataManager = .shared

    // MARK: - Transform
    
    func transform(input: Input) -> Output {

        input.loadTrigger
            .flatMapLatest { [unowned self] in
                self.coreDataManager.fetchBooks()
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

        input.addTrigger
            .flatMapLatest { [unowned self] item in
                self.coreDataManager.saveBook(item)
                    .andThen(self.coreDataManager.fetchBooks())
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
                self.coreDataManager.deleteBook(byISBN: isbn)
                    .andThen(self.coreDataManager.fetchBooks())
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
                self.coreDataManager.deleteBooks()
                    .andThen(self.coreDataManager.fetchBooks())
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
            error: errorRelay.asDriver(onErrorJustReturn: "Unknown Error")
        )
    }
}
