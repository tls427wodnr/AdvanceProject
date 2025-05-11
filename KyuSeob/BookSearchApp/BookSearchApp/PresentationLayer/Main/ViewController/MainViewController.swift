//
//  MainViewController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

    private let mainView = MainView()
    private let viewModel = MainViewModel()

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

}

private extension MainViewController {
    private func bind() {
        mainView.dummyBtnTapped
            .bind(to: viewModel.dummyButtonTapped)
            .disposed(by: disposeBag)

        viewModel.showDetailView
            .subscribe(onNext: {
                let detailViewController = BookDetailViewController()
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }).disposed(by: disposeBag)
    }
}
