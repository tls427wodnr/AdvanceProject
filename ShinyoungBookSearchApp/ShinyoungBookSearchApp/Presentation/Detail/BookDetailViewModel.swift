//
//  BookDetailViewModel.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import RxSwift
import RxCocoa

final class BookDetailViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let saveButtonTapped: Observable<Void>
    }
    
    struct Output {
        let dismissWithSaveFlag: Signal<Bool>
        let showError: Signal<String>
    }
    
    private let saveBookUseCase: SaveBookUseCase
    
    private let book: Book
    
    private let disposeBag = DisposeBag()
    
    init(book: Book, saveBookUseCase: SaveBookUseCase) {
        self.book = book
        self.saveBookUseCase = saveBookUseCase
    }
    
    func transform(input: Input) -> Output {
        let dismissWithSaveFlag = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.saveRecentBook()
            })
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.saveFavoriteBook(
                    onSuccess: { dismissWithSaveFlag.accept(true) },
                    onFailure: { _ in
                        errorMessage.accept("책 저장에 실패했습니다.")
                    }
                )
            })
            .disposed(by: disposeBag)
        
        return Output(
            dismissWithSaveFlag: dismissWithSaveFlag.asSignal(),
            showError: errorMessage.asSignal()
        )
    }
    
    func saveFavoriteBook(
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        saveBookUseCase.executeSaveFavorite(book: book)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { onSuccess() },
                onFailure: { onFailure($0) }
            )
            .disposed(by: disposeBag)
    }
    
    func saveRecentBook() {
        saveBookUseCase.executeSaveRecent(book: book)
            .subscribe(onFailure: { error in
                    print("최근 본 책 저장 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
