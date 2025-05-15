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
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .label
    }

    private let dividerView = UIView().then {
        $0.backgroundColor = .init(hex: "e6e6e6")
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
        addSubviews(views: titleLabel, dividerView)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        dividerView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}
