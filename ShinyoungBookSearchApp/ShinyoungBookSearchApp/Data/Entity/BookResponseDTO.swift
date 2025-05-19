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
    let isbn: String
    
    enum CodingKeys: String, CodingKey {
        case title, authors, thumbnail, contents, isbn
        case salePrice = "sale_price"
    }
}

extension BookResponseDTO {
    func toDomain() -> Book {
        Book(
            title: title,
            authors: authors.joined(separator: ", "),
            salePrice: "₩" + formatPrice(salePrice),
            thumbnailURL: thumbnail,
            contents: contents,
            isbn: isbn
        )
    }

    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
