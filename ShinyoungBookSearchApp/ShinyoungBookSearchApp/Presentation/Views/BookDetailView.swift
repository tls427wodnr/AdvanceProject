//
//  BookDetailView.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit
import Kingfisher

final class BookDetailView: UIView {
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let authorStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .leading
        return sv
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let bookPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let bookDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("책 담기", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        [dismissButton, saveButton].forEach {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        [
            dismissButton,
            saveButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        
        [
            bookImageView,
            authorStackView,
            bookTitleLabel,
            bookDescriptionLabel,
            bookPriceLabel,
        ].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            scrollView,
            buttonStackView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(buttonStackView.snp.top)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(64)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.45)
        }
        
        authorStackView.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.lessThanOrEqualToSuperview().inset(24)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalTo(authorStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        bookDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        bookPriceLabel.snp.makeConstraints {
            $0.top.equalTo(bookDescriptionLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalTo(contentView).inset(24)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(60)
        }
    }
    
    func configure(with book: Book) {
        bookTitleLabel.text = book.title
        bookImageView.kf.setImage(with: URL(string: book.thumbnailURL))
        bookPriceLabel.text = book.salePrice
        bookDescriptionLabel.text = book.contents
        
        authorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let authors = book.authors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        authors.forEach { name in
            let label = PaddingLabel()
            label.text = name
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = .white
            label.backgroundColor = .black
            label.layer.cornerRadius = 16
            label.clipsToBounds = true
            label.textInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
            authorStackView.addArrangedSubview(label)
        }
    }
}

final class PaddingLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
