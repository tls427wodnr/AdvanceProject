//
//  BookResponseDTO.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import Foundation

struct BookSearchResponse: Decodable {
    let meta: Meta?
    let documents: [BookResponseDTO]
}

struct Meta: Decodable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}

struct BookResponseDTO: Decodable {
    let title: String
    let authors: [String]
    let salePrice: Int
    let thumbnail: String
    let contents: String?
    
    enum CodingKeys: String, CodingKey {
        case title, authors
        case salePrice = "sale_price"
        case thumbnail, contents
    }
}

extension BookResponseDTO {
    func toDomain() -> Book {
        Book(
            title: title,
            authors: authors.joined(separator: ", "),
            salePrice: "₩" + formatPrice(salePrice),
            thumbnailURL: thumbnail,
            contents: contents
        )
    }

    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
