//
//  BookTableCell.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BookTableCell: UITableViewCell {
    
    static let identifier = "BookTableCell"
    
    // MARK: - UI Components

    private let shadowContainerView = UIView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = false
    }

    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .tertiarySystemFill
    }

    private let titleLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .label
        $0.numberOfLines = 2
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

    private let textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .fill
        $0.distribution = .fill
    }

    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .top
    }

    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.clipsToBounds = false
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    
    private func setupLayout() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = false
        
        textStackView.addArrangedSubview(titleLabel)

        let subInfoStack = UIStackView(arrangedSubviews: [publisherLabel, UIView(), priceLabel])
        subInfoStack.axis = .horizontal
        subInfoStack.spacing = 8
        subInfoStack.alignment = .center

        textStackView.addArrangedSubview(subInfoStack)

        shadowContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        hStackView.addArrangedSubview(shadowContainerView)
        hStackView.addArrangedSubview(textStackView)

        contentView.addSubview(hStackView)
        contentView.addSubview(separatorView)

        hStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(16)
        }

        shadowContainerView.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(90)
        }

        separatorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    // MARK: - Configuration
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        publisherLabel.text = book.publisher
        priceLabel.text = "\(book.price.formattedWithComma())원"

        if let url = URL(string: book.thumbnail) {
            thumbnailImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "book"))
        } else {
            thumbnailImageView.image = UIImage(systemName: "book")
        }
    }
}
