//
//  MainViewModel.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let searchBooksUseCase: SearchBooksUseCaseProtocol

    let searchResultBooks = PublishRelay<[Book]>()

    private let disposeBag = DisposeBag()

    init(searchBooksUseCase: SearchBooksUseCaseProtocol) {
        self.searchBooksUseCase = searchBooksUseCase
    }
}

extension MainViewModel {
    func searchBooks(with query: String) {
        searchBooksUseCase.searchBooks(query: query)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] result in
                self?.searchResultBooks.accept(result)
                print("검색 결과: \(result)")
            }, onFailure: { error in
                print("검색 에러: \(error)")
            }).disposed(by: disposeBag)
    }
}
