//
//  SearchViewModel.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import RxSwift

final class SearchViewModel {
    private let searchBooksUseCase: SearchBooksUseCase
    private let disposeBag = DisposeBag()

    // 입력
    let searchQuery = PublishSubject<String>()

    // 출력
    let books = PublishSubject<[Book]>()

    init(searchBooksUseCase: SearchBooksUseCase) {
        self.searchBooksUseCase = searchBooksUseCase
        bind()
    }

    private func bind() {
        searchQuery
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[Book]> in
                guard let self = self else { return .just([]) }

                return self.searchBooksUseCase.execute(query: query)
                    .asObservable()
                    .catchAndReturn([]) // 에러 발생 시 빈 배열
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books.onNext(books)
            })
            .disposed(by: disposeBag)
    }
}
