//
//  BookDTO.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

// MARK: - 단일 책 DTO
struct BookDTO: Decodable {
    let authors: [String]
    let contents: String
    let datetime: String
    let isbn: String
    let price: Int
    let publisher: String
    let sale_price: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String

    func toEntity() -> Book {
        return Book(
            title: title,
            thumbnail: thumbnail,
            authors: authors,
            contents: contents,
            publisher: publisher,
            url: url,
            price: price,
            isbn: isbn
        )
    }
}
