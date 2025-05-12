//
//  SearchResultTableViewCell.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit

class SearchResultTableViewCell: UICollectionViewCell {
    static let identifier = "SearchResultTableViewCell"

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    private let authorLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private let priceLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(book: Book) {
        titleLabel.text = book.title
        authorLabel.text = {
            let authorsCount = book.authors.count
            switch authorsCount {
            case 0:
                return ""
            case 1:
                return book.authors.first
            default:
                return "\(book.authors.first ?? "") 외 \(authorsCount - 1)"
            }
        }()
        priceLabel.text = String(book.price) + "원"
    }
}

private extension SearchResultTableViewCell {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()
    }

    func setStyle() {
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.black.cgColor

        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        authorLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    func setHierarchy() {
        contentView.addSubviews(views: titleLabel, authorLabel, priceLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(120)
        }

        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }

        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }

    func bind() {

    }
}
