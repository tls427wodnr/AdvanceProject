//
//  EmptyView.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import UIKit
import SnapKit
import Then

class EmptyView: UIView {
    private let emptyIconImageView = UIImageView().then {
        let configuration = UIImage.SymbolConfiguration(pointSize: 50)
        $0.image = .init(systemName: "text.book.closed")
        $0.tintColor = .secondaryLabel
    }

    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .secondaryLabel
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(with message: String) {
        emptyLabel.text = message
    }
}

private extension EmptyView {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
    }

    func setStyle() {
        backgroundColor = .systemBackground
    }

    func setHierarchy() {
        addSubviews(views: emptyIconImageView, emptyLabel)
    }

    func setConstraints() {
        emptyIconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(60)
        }

        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyIconImageView.snp.bottom).offset(20)
        }
    }
}

