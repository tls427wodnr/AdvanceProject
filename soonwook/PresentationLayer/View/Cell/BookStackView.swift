//
//  BookStackView.swift
//  Book
//
//  Created by 권순욱 on 5/10/25.
//

import UIKit
internal import SnapKit

// 책 정보 검색 뷰와 장바구니 뷰에서 공통 사용됨.
class BookStackView: UIStackView {
    // 책 제목
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    // 저자
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    // 가격
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        spacing = 8
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .systemGray6
        
        [titleLabel, authorLabel, priceLabel].forEach {
            addArrangedSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(100)
        }
        
        authorLabel.snp.makeConstraints {
            $0.width.equalTo(60)
        }
        
        priceLabel.snp.makeConstraints {
            $0.width.equalTo(70)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
