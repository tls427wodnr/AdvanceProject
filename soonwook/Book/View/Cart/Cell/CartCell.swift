//
//  CartCell.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import UIKit

class CartCell: UITableViewCell {
    static let reuseIdentifier = "CartCell"
    
    // 책 정보(책 제목, 저자, 가격)
    let stackView = BookStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
