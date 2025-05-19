//
//  UIView+.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import UIKit

extension UIView {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toast = ToastView(message: message)
        addSubview(toast)

        toast.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }

        layoutIfNeeded()

        UIView.animate(withDuration: 0.3, animations: {
            toast.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toast.alpha = 0.0
            }) { _ in
                toast.removeFromSuperview()
            }
        }
    }
    
    func popAnimation(scale: CGFloat = 0.95, duration: TimeInterval = 0.1) {
            UIView.animate(withDuration: duration,
                           animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }, completion: { _ in
                UIView.animate(withDuration: duration) {
                    self.transform = .identity
                }
            })
        }
}
