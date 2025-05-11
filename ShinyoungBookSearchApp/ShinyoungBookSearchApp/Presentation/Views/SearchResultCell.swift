//
//  SearchResultCell.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

final class SearchResultCell: UICollectionViewCell {
    static let id = "SearchResultCell"
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let bookPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let bookInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
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
        [
            bookTitleLabel,
            authorLabel,
            bookPriceLabel
        ].forEach { bookInfoStackView.addArrangedSubview($0) }
        
        [bookInfoStackView].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        bookInfoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }
    }
    
    override func prepareForReuse() {
        bookTitleLabel.text = nil
        authorLabel.text = nil
        bookPriceLabel.text = nil
    }
    
    func configure(with book: Book) {
        bookTitleLabel.text = book.title
        authorLabel.text = book.authors
        bookPriceLabel.text = book.salePrice
    }
}
