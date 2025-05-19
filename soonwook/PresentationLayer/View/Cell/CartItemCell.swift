//
//  CartItemCell.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import UIKit
import DomainLayer

class CartItemCell: UITableViewCell {
    static let reuseIdentifier = "CartItemCell"
    
    // 책 정보(책 제목, 저자, 가격)
    let stackView = BookStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let insets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        contentView.frame = contentView.frame.inset(by: insets)
    }
    
    func update(with item: CartItem) {
        stackView.titleLabel.text = item.title
        stackView.authorLabel.text = item.author
        stackView.priceLabel.text = item.price.wonFormatter()
    }
}
