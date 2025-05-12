//
//  BookCell.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import UIKit
import SnapKit
import Then

final class BookCell: UICollectionViewCell {
    
    static let identifier = "BookCell"

    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .label
        $0.numberOfLines = 1
    }

    private let publisherLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.textColor = .secondaryLabel
    }

    private let priceLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .label
        $0.textAlignment = .right
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)

        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }

        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(1)
        }

        stackView.addArrangedSubview(titleLabel)

        let hStack = UIStackView(arrangedSubviews: [publisherLabel, UIView(), priceLabel])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center

        stackView.addArrangedSubview(hStack)
    }

    func configure(with book: Book) {
        titleLabel.text = book.title
        publisherLabel.text = book.publisher
        priceLabel.text = "\(book.price.formattedWithComma())원"
    }
}
