//
//  SearchResultDTO.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation

struct SearchResultResponse: Codable {
    let meta: Meta?
    let documents: [Document]
}

struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct Document: Codable {
    let title: String
    let contents: String
    let url: String
    let authors: [String]
    let price: Int
}
