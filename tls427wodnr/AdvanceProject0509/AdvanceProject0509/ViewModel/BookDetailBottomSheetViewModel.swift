//
//  BookDetailBottomSheetViewModel.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BookDetailBottomSheetViewModel {

    // MARK: - Input

    struct Input {
        let addTrigger: Observable<Void>
    }

    // MARK: - Output

    struct Output {
        let added: Driver<Void>
        let error: Driver<String>
    }

    // MARK: - Properties

    private let book: BookItem
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()

    private let addedRelay = PublishRelay<Void>()
    private let errorRelay = PublishRelay<String>()

    // MARK: - Init

    init(book: BookItem, coreDataManager: CoreDataManager = .shared) {
        self.book = book
        self.coreDataManager = coreDataManager
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        input.addTrigger
            .flatMapLatest { [unowned self] in
                coreDataManager.saveBook(book)
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .completed:
                    self?.addedRelay.accept(())
                case .error(let error):
                    self?.errorRelay.accept(error.localizedDescription)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        return Output(
            added: addedRelay.asDriver(onErrorDriveWith: .empty()),
            error: errorRelay.asDriver(onErrorJustReturn: "알 수 없는 오류")
        )
    }
}
