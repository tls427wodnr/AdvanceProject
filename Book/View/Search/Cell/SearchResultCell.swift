//
//  SearchResultCell.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import UIKit
import SnapKit

class SearchResultCell: UICollectionViewCell {
    static let reuseIdentifier = "SearchResultCell"
    
    let stackView = BookStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with book: Book) {
        stackView.titleLabel.text = book.title
        stackView.authorLabel.text = book.author
        stackView.priceLabel.text = book.price.wonFormatter()
    }
}
