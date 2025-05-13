//
//  UIViewController+.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import UIKit

extension UIViewController {

    // 단순 확인용 에러 메시지 Alert
    func showNoticeAlert(message: String, title: String = "에러", checkHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            checkHandler?()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }

    // 확인, 취소 여부를 묻는 Alert
    func showConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        confirmStyle: UIAlertAction.Style = .default,
        cancelStyle: UIAlertAction.Style = .cancel,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirm = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            onConfirm()
        }

        let cancel = UIAlertAction(title: cancelTitle, style: cancelStyle) { _ in
            onCancel?()
        }

        alert.addAction(cancel)
        alert.addAction(confirm)

        present(alert, animated: true)
    }
}
