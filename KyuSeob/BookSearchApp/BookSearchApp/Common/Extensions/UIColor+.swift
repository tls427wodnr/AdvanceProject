//
//  UIColor+.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit

extension UIColor {
    // Hex 문자열을 UIColor로 변환하는 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        // Hex 문자열 길이에 따라 RGB 값을 추출
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        // UIColor 초기화
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
