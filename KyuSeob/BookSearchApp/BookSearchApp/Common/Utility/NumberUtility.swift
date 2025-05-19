//
//  NumberUtility.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation

final class NumberUtility {
    static let shared = NumberUtility()

    func formatWithComma(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard let result = numberFormatter.string(from: NSNumber(value: number)) else { return "" }
        return result
    }
}
