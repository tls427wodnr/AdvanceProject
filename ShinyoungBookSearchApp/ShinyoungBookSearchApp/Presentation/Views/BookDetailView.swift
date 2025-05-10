//
//  BookDetailView.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

final class BookDetailView: UIView {
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let bookPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private let bookDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
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
            bookTitleLabel,
            bookAuthorLabel,
            bookImageView,
            bookPriceLabel,
            bookDescriptionLabel,
            buttonStackView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        bookAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(bookAuthorLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        bookPriceLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        bookDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bookPriceLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(60)
        }
    }
    
    func configure(with book: Book) {
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.authors
        bookImageView.image = UIImage(named: book.thumbnailURL)
        bookPriceLabel.text = book.salePrice
        bookDescriptionLabel.text = book.contents
    }
}
