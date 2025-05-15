//
//  BookDetailViewController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxSwift
import SnapKit
import Then

class BookDetailViewController: UIViewController {
    private let bookDetailViewModel: BookDetailViewModel
    private let disposeBag = DisposeBag()

    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView().then {
        $0.backgroundColor = .systemBackground
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .label
    }

    private let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .gray
    }

    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.shadowColor = UIColor(hex: "1A1A1A")?.cgColor
        $0.clipsToBounds = true
    }

    private let priceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = .label
    }

    private let contentsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .label
        $0.lineBreakMode = .byWordWrapping
    }

    private let closeButton = UIButton().then {
        $0.setImage(.init(systemName: "xmark"), for: .normal)
        $0.tintColor = .systemBackground
        $0.backgroundColor = .init(hex: "999999")
        $0.layer.cornerRadius = 15
    }

    private let cartButton = UIButton().then {
        $0.setTitle("담기", for: .normal)
        $0.tintColor = .systemBackground
        $0.backgroundColor = .init(hex: "63c466")
        $0.layer.cornerRadius = 15
    }

    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
    }

    init(bookDetailViewModel: BookDetailViewModel) {
        self.bookDetailViewModel = bookDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

}

private extension BookDetailViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()

        self.presentationController?.delegate = self
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
    }

    func setHierarchy() {
        horizontalStackView.addArrangedSubviews(views: closeButton, cartButton)
        view.addSubviews(views: scrollView, horizontalStackView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(views: titleLabel, authorLabel, thumbnailImageView, priceLabel, contentsLabel)
    }

    func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        horizontalStackView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(52)
        }

        cartButton.snp.makeConstraints {
            $0.width.equalTo(closeButton.snp.width).multipliedBy(4.0)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(1.5)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(40)
        }
    }

    func bind() {
        bookDetailViewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        bookDetailViewModel.authors
            .drive(authorLabel.rx.text)
            .disposed(by: disposeBag)

        bookDetailViewModel.contents
            .drive(contentsLabel.rx.text)
            .disposed(by: disposeBag)

        bookDetailViewModel.thumbnail
            .drive(thumbnailImageView.rx.image)
            .disposed(by: disposeBag)

        bookDetailViewModel.price
            .drive(priceLabel.rx.text)
            .disposed(by: disposeBag)

        cartButton.rx.tap
            .bind(to: bookDetailViewModel.cartButtonTapped)
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .bind(to: bookDetailViewModel.closeButtonTapped)
            .disposed(by: disposeBag)

        bookDetailViewModel.didSuccessEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] event in
                guard let self else { return }
                switch event {
                case .cartBookSaved:
                    self.dismiss(animated: true) {
                        self.bookDetailViewModel.detailViewDismissed.accept(())
                    }
                case .close: self.dismiss(animated: true) {
                    self.bookDetailViewModel.detailViewDismissed.accept(())
                }
                }
            }).disposed(by: disposeBag)

        bookDetailViewModel.didFailedEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("CartBook event failed: \(error)")
                self.showNoticeAlert(message: error.localizedDescription) // TODO: - 커스텀 에러 discription 정의 시 수정 필요
            }).disposed(by: disposeBag)

        bookDetailViewModel.detailViewEntered
            .accept(())
    }
}

extension BookDetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) { // 직접 드래그를 내려 페이지를 dismiss하는 경우
        bookDetailViewModel.detailViewDismissed.accept(())
    }
}
