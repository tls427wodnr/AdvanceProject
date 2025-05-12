//
//  SearchResultHeaderView.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/12/25.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}

private extension SectionHeaderView {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        addSubviews(views: titleLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
