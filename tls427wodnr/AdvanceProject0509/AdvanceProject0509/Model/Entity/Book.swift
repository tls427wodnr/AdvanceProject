//
//  Book.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import Foundation

struct BookResponse: Codable {
    let items: [BookItem]
}

struct BookItem: Codable {
    let isbn: String
    let title: String
    let image: String
    let author: String
    let publisher: String
    let description: String
}
