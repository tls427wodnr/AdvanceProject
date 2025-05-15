//
//  Meta.swift
//  Book
//
//  Created by 권순욱 on 5/15/25.
//

import Foundation

public struct Meta: Decodable {
    public let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
    }
}
