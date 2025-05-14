//
//  RecentBookListViewModel.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import RxSwift
import RxCocoa

final class RecentBookListViewModel {
    // MARK: - Input
    struct Input {
        let loadTrigger: Observable<Void>
        let addBook: Observable<BookItem>
    }

    // MARK: - Output
    struct Output {
        let books: Driver<[BookItem]>
    }

    // MARK: - Private
    private let useCase: LocalRecentBookUseCaseProtocol
    private let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(useCase: LocalRecentBookUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Transform
    func transform(input: Input) -> Output {
        input.loadTrigger
            .flatMapLatest { [weak self] _ -> Single<[BookItem]> in
                guard let self = self else { return .just([]) }
                return self.useCase.loadRecentBooks()
            }
            .bind(to: booksRelay)
            .disposed(by: disposeBag)

        input.addBook
            .flatMapLatest { [weak self] book -> Single<[BookItem]> in
                guard let self = self else { return .just([]) }
                return self.useCase.addRecentBook(book).andThen(self.useCase.loadRecentBooks())
            }
            .bind(to: booksRelay)
            .disposed(by: disposeBag)

        return Output(books: booksRelay.asDriver())
    }
}
