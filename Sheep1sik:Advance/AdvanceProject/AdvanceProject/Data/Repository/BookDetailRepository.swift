//
//  BookDetailRepository.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//

protocol BookDetailRepository {
    func isBookAlreadyStored(_ book: Book) -> Bool
    func save(book: Book)
}
