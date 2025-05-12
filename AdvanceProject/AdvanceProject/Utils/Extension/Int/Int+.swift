//
//  Int+.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/12/25.
//

import Foundation

extension Int {
    func formattedWithComma() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
