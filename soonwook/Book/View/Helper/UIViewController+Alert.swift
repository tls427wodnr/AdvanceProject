//
//  UIViewController+Alert.swift
//  Book
//
//  Created by 권순욱 on 5/12/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("확인", comment: "Alert OK button title")
        alert.addAction(
            UIAlertAction(
                title: actionTitle, style: .default,
                handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
        present(alert, animated: true, completion: nil)
    }
}
