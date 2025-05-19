//
//  BookDetailView.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BookDetailView: UIView {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 22)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
    }

    private let coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }

    private let priceLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textAlignment = .center
    }

    private let contentsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }

    let addButton = UIButton().then {
        $0.setTitle("담기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 10
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    private func setupLayout() {
        addSubview(scrollView)
        addSubview(addButton)
        scrollView.addSubview(contentView)

        [titleLabel, authorLabel, coverImageView, priceLabel, contentsLabel].forEach {
            contentView.addSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addButton.snp.top).offset(-12)
        }

        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        coverImageView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(400)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(coverImageView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }

        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(48)
        }
    }

    // MARK: - Public
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: ", ")
        priceLabel.text = "\(book.price.formattedWithComma())원"
        contentsLabel.text = book.contents

        if let url = URL(string: book.thumbnail) {
            coverImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "book"))
        }
    }
}
