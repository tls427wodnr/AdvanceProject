//
//  History.swift
//  Book
//
//  Created by 권순욱 on 5/13/25.
//

import Foundation

public struct History {
    public let isbn: String
    public let title: String
    public let authors: [String]
    public let price: Int
    public let contents: String
    public let thumbnail: String
    public let timestamp: Date
}

extension History {
    public var author: String {
        authors.isEmpty ? "" : authors[0]
    }
}
