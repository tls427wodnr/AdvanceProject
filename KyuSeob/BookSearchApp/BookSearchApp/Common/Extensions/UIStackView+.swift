//
//  UIStackView+.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/12/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
