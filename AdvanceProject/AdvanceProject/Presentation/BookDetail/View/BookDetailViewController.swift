//
//  BookDetailViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit
import RxSwift

final class BookDetailViewController: UIViewController {
    private let bookDetailView = BookDetailView()
    private let viewModel: BookDetailViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = bookDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bookDetailView.configure(with: viewModel.book)
        bookDetailView.addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        setupNavigation()
    }

    private func setupNavigation() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.leftBarButtonItem = closeButton
        title = "책 상세"
    }

    private func animateAddButton() {
        let button = bookDetailView.addButton
        UIView.animate(withDuration: 0.1,
                       animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        })
    }

    @objc private func didTapClose() {
        viewModel.didTapClose()
    }

    @objc private func didTapAdd() {
        animateAddButton()

        viewModel.tryAddBook()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isNew in
                guard let self = self else { return }
                if isNew {
                    self.view.showToast(message: "장바구니에 담겼습니다")
                    Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
                        .subscribe(onNext: { [weak self] _ in
                            self?.viewModel.didTapAddBook()
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    self.view.showToast(message: "이미 담은 책입니다")
                }
            })
            .disposed(by: disposeBag)

    }
}
