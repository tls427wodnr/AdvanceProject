//
//  RecentBookCell.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import UIKit
import SnapKit
import Kingfisher

final class RecentBookCell: UICollectionViewCell {
    static let id = "RecentBookCell"

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with url: String) {
        if let url = URL(string: url) {
            imageView.kf.setImage(with: url)
        }
    }
}
