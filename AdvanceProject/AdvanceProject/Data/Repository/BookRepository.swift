//
//  BookRepository.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import RxSwift

protocol BookRepository {
    func searchBooks(query: String) -> Single<[Book]>
}
