//
//  UIView+.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit

extension UIView {
    func addSubviews(views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
