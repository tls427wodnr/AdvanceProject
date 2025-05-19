//
//  RecentBookCollectionViewCell.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/15/25.
//

import UIKit
import RxSwift

final class RecentBookCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecentBookCollectionViewCell"
    private let disposeBag = DisposeBag()

    private let shadowContainerView = UIView()
    private let thumbnailImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(with thumbnailURL: String) {
        ImageLoader.shared.load(from: thumbnailURL)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] image in
                    guard let self else { return }
                    if let image {
                        self.thumbnailImageView.image = image
                    } else {
                        print("image is nil")
                        self.thumbnailImageView.image = UIImage(systemName: "text.book.closed")
                    }
                },
                onFailure: { _ in
                    self.thumbnailImageView.image = UIImage(
                        systemName: "xmark"
                    )?.withTintColor(
                        .init(
                            hex: "e6e6e6"
                        ) ?? .lightGray,
                        renderingMode: .alwaysOriginal
                    )


            }).disposed(by: disposeBag)
    }
}

private extension RecentBookCollectionViewCell {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
    }

    func setStyle() {
        contentView.backgroundColor = .clear
        shadowContainerView.layer.cornerRadius = 10
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.2
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowContainerView.layer.masksToBounds = false
//        shadowContainerView.backgroundColor = .lightGray

        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
    }

    func setHierarchy() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.addSubview(thumbnailImageView)
    }

    func setConstraints() {
        shadowContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
