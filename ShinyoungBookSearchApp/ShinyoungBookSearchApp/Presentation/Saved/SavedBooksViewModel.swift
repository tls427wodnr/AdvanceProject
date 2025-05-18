//
//  SavedBooksViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SavedBooksViewModel {
    struct Input {
        let viewWillAppear: Observable<Void>
        let deleteAllTaps: Observable<Void>
        let swipeToDelete: Observable<String>
    }
    
    struct Output {
        let books: Driver<[Book]>
        let showError: Signal<String>
    }
    
    private let savedBooksUseCase: SavedBooksUseCase
    
    private let disposeBag = DisposeBag()
    
    private let savedBooksSubject = BehaviorSubject<[Book]>(value: [])
    private let errorMessageRelay = PublishRelay<String>()
    
    init(savedBooksUseCase: SavedBooksUseCase) {
        self.savedBooksUseCase = savedBooksUseCase
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMapLatest { [weak self] _ -> Observable<[Book]> in
                guard let self else { return .empty() }
                return self.savedBooksUseCase.fetchSavedBooks()
                    .asObservable()
                    .catch { [weak self] error in
                        self?.errorMessageRelay.accept("목록을 불러오지 못했습니다.")
                        return .empty()
                    }
            }
            .bind(to: savedBooksSubject)
            .disposed(by: disposeBag)
        
        input.deleteAllTaps
            .flatMapLatest { [weak self] _ -> Observable<[Book]> in
                guard let self else { return .empty() }
                return self.savedBooksUseCase.deleteAllBooks()
                    .flatMap { self.savedBooksUseCase.fetchSavedBooks() }
                    .asObservable()
                    .catch { [weak self] error in
                        self?.errorMessageRelay.accept("전체 삭제에 실패했습니다.")
                        return .empty()
                    }
            }
            .bind(to: savedBooksSubject)
            .disposed(by: disposeBag)
        
        input.swipeToDelete
            .flatMapLatest { [weak self] isbn -> Observable<[Book]> in
                guard let self else { return .empty() }
                return self.savedBooksUseCase.deleteBook(isbn: isbn)
                    .flatMap { self.savedBooksUseCase.fetchSavedBooks() }
                    .asObservable()
                    .catch { [weak self] error in
                        self?.errorMessageRelay.accept("삭제에 실패했습니다.")
                        return .empty()
                    }
            }
            .bind(to: savedBooksSubject)
            .disposed(by: disposeBag)
        
        return Output(
            books: savedBooksSubject.asDriver(onErrorJustReturn: []),
            showError: errorMessageRelay.asSignal()
        )
    }
}
