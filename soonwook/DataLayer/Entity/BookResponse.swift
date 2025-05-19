//
//  BookResponse.swift
//  Book
//
//  Created by 권순욱 on 5/14/25.
//

import Foundation
import DomainLayer

struct BookResponse: Decodable {
    let documents: [Book]
    let meta: Meta
}
