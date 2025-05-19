//
//  Int+Formatter.swift
//  Book
//
//  Created by 권순욱 on 5/9/25.
//

import Foundation

extension Int {
    // 1000 -> 1,000원
    func wonFormatter() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // .currency로 바꾸면 앞에 W 붙일 수 있음.
        formatter.locale = Locale(identifier: "ko_KR")
        
        if let price = formatter.string(from: NSNumber(value: self)) {
            return "\(price)원"
        } else {
            return ""
        }
    }
}
