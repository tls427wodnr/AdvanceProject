//
//  CartBookListViewModel.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CartBookListViewModel {
    private let cartBookUseCase: CartBookUseCaseProtocol
    private let disposeBag = DisposeBag()
    let cartBooks = BehaviorRelay<[CartBook]>(value: [])

    enum CartBookListEvent {
        case deleteAll
        case deleteOne
    }

    let didSuccessEvent = PublishRelay<CartBookListEvent>()
    let didFailedEvent = PublishRelay<Error>()
    let deleteAllTapped = PublishRelay<Void>()
    let addTapped = PublishRelay<Void>()
    let deleteOneTapped = PublishRelay<CartBook>()

    init(cartBookUseCase: CartBookUseCaseProtocol) {
        self.cartBookUseCase = cartBookUseCase
        bind()
    }

    func fetchCartBooks() {
        do {
            let books = try cartBookUseCase.fetchCartBooks()
            print(books)
            cartBooks.accept(books)
        } catch {
            self.didFailedEvent.accept(error)
        }
    }
}

private extension CartBookListViewModel {
    private func bind() {
        deleteAllTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                do {
                    try self.cartBookUseCase.deleteAllCartBooks()
                    self.didSuccessEvent.accept(.deleteAll)
                } catch {
                    self.didFailedEvent.accept(error)
                }
            }, onError: { [weak self] error in
                guard let self else { return }
                self.didFailedEvent.accept(error)
            }).disposed(by: disposeBag)

        deleteOneTapped
            .subscribe(onNext: { [weak self] cartBook in
                guard let self else { return }
                do {
                    try self.cartBookUseCase.deleteCartBook(cartBook: cartBook)
                    self.didSuccessEvent.accept(.deleteOne)
                } catch {
                    self.didFailedEvent.accept(error)
                }
            }).disposed(by: disposeBag)
    }
}
