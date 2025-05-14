//
//  RecentBookListViewModel.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import RxSwift
import RxCocoa

struct RecentBookListViewModelInput {
    let loadTrigger: Observable<Void>
    let addBook: Observable<BookItem>
}

struct RecentBookListViewModelOutput {
    let books: Driver<[BookItem]>
}

protocol RecentBookListViewModelProtocol {
    func transform(input: RecentBookListViewModelInput) -> RecentBookListViewModelOutput
}

final class RecentBookListViewModel: RecentBookListViewModelProtocol {

    // MARK: - Private
    
    private let useCase: LocalRecentBookUseCaseProtocol
    private let booksRelay = BehaviorRelay<[BookItem]>(value: [])
    private let disposeBag = DisposeBag()

    // MARK: - Init
    
    init(useCase: LocalRecentBookUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Transform
    
    func transform(input: RecentBookListViewModelInput) -> RecentBookListViewModelOutput {
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

        return RecentBookListViewModelOutput(books: booksRelay.asDriver())
    }
}
