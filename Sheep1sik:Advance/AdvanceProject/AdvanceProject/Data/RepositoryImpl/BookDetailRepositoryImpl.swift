//
//  BookDetailRepositoryImpl.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

final class BookDetailRepositoryImpl: BookDetailRepository {
    func isBookAlreadyStored(_ book: Book) -> Bool {
        CoreDataManager.shared.isBookAlreadyStored(book)
    }

    func save(book: Book) {
        CoreDataManager.shared.save(book: book)
    }
}
