//
//  ToastView.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit
import SnapKit

final class ToastView: UIView {

    private let messageLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.75)
        layer.cornerRadius = 10
        clipsToBounds = true
        alpha = 0

        messageLabel.text = message
        addSubview(messageLabel)

        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
