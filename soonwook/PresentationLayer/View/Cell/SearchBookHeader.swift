//
//  SearchBookHeader.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import UIKit
internal import SnapKit

// section에 따라 "최근 본 책" 또는 "검색 결과"
class SearchBookHeader: UICollectionReusableView {
    static let reuseIdentifier = "SearchBookHeader"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().offset(8)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        label.text = text
    }
}
