//
//  Book.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import Foundation
import RxDataSources

// MARK: - DTO

struct BookResponse: Codable {
    let items: [BookItem]
}

// MARK: - Model

struct BookItem: Codable {
    let isbn: String
    let title: String
    let image: String
    let author: String
    let publisher: String
    let description: String
}
