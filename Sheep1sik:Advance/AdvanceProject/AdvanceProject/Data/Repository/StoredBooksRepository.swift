//
//  StoredBooksRepository.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/13/25.
//

import Foundation

protocol StoredBooksRepository {
    func fetchStoredBooks() -> [Book]
    func delete(book: Book)
    func deleteAll()
}
