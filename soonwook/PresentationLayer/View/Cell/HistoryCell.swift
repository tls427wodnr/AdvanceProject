//
//  HistoryCell.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit
internal import SnapKit
import DomainLayer

class HistoryCell: UICollectionViewCell {
    static let reuseIdentifier = "HistoryCell"
    
    // 책 이미지
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
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
    
    func update(with history: History) {
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: history.thumbnail),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.sync {
                    self?.imageView.image = image
                }
            }
        }
    }
}
