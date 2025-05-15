//
//  BookDetailViewModel.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/12/25.
//

import UIKit
import RxSwift
import RxCocoa

final class BookDetailViewModel {
    enum BookDetailEvent {
        case cartBookSaved // CartBook이 저장됨
        case close // 페이지 닫기
    }

    private let cartBookUseCase: CartBookUseCaseProtocol
    private let book: Book
    private let disposeBag = DisposeBag()

    var title: Driver<String>
    var authors: Driver<String>
    var contents: Driver<String>
    var thumbnail: Driver<UIImage?>
    var price: Driver<String>

    let cartButtonTapped = PublishRelay<Void>()
    let closeButtonTapped = PublishRelay<Void>()
    let didSuccessEvent = PublishRelay<BookDetailEvent>()
    let didFailedEvent = PublishRelay<Error>()

    init(book: Book, cartBookUseCase: CartBookUseCaseProtocol) {
        self.book = book
        self.cartBookUseCase = cartBookUseCase

        self.title = .just(book.title).asDriver(onErrorJustReturn: "")
        self.authors = Observable.just(book.authors)
            .map { value in
                switch value.count {
                case 0: return "저자 미상"
                case 1: return value.first ?? ""
                default:
                    return "\(value.first ?? "") 외 \(value.count - 1)명"
                }
            }
            .asDriver(onErrorJustReturn: "저자 미상")
        self.contents = .just(book.contents).asDriver(onErrorJustReturn: "")

        self.thumbnail = ImageLoader.shared.load(from: book.thumbnail)
            .asDriver(onErrorJustReturn: UIImage(named: "xmark"))
        self.price = Observable.just(book.price)
            .map { value in
                "\(NumberUtility.shared.formatWithComma(value))원"
            }
            .asDriver(onErrorJustReturn: "")

        bind()
    }
}

private extension BookDetailViewModel {
    private func bind() {
        cartButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                do {
                    try self.cartBookUseCase.save(book: self.book)
                    self.didSuccessEvent.accept(.cartBookSaved)
                } catch {
                    self.didFailedEvent.accept(error)
                }
            }, onError: { [weak self] error in
                guard let self else { return }
                self.didFailedEvent.accept(error)
            }).disposed(by: disposeBag)

        closeButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                print("closeButtonTapped")
                self.didSuccessEvent.accept(.close)
            }).disposed(by: disposeBag)
    }
}
