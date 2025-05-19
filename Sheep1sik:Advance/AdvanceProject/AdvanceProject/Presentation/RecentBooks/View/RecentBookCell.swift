//
//  RecentBookCell.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

import UIKit
import SnapKit
import Then


final class RecentBookCell: UICollectionViewCell {
    static let identifier = "RecentBookCell"

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25 // 반지름 = 너비 절반
        $0.backgroundColor = .tertiarySystemFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }

        // 그림자 효과 추가
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }


    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with book: RecentBook) {
        if let url = URL(string: book.thumbnail) {
            imageView.kf.setImage(with: url)
        }
    }
}
