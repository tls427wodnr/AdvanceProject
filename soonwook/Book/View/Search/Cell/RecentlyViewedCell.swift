//
//  RecentlyViewedCell.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit
import SnapKit

class RecentlyViewedCell: UICollectionViewCell {
    static let reuseIdentifier = "RecentlyViewedCell"
    
    // 책 이미지
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with image: UIImage) {
        imageView.image = image
    }
}
