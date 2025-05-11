//
//  BookDetailView.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit

final class MainView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}

private extension MainView {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setAction()
    }

    func setStyle() {

    }

    func setHierarchy() {

    }

    func setConstraints() {

    }

    func setAction() {

    }
}

