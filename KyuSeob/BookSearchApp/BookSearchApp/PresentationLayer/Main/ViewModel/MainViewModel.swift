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

    let dummyButtonTapped = PublishRelay<Void>()
    let showDetailView = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {
        dummyButtonTapped
            .subscribe(onNext: {
                self.showDetailView.accept(())
            })
            .disposed(by: disposeBag)
    }

}
