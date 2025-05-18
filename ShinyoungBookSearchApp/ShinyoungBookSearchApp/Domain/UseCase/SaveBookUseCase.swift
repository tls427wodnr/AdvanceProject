//
//  SaveBookUseCase.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/18/25.
//

import RxSwift

protocol SaveBookUseCase {
    func executeSaveFavorite(book: Book) -> Single<Void>
    func executeSaveRecent(book: Book) -> Single<Void>
}

final class DefaultSaveBookUserCase: SaveBookUseCase {
    private let repository: BookRepository
    
    init(repository: BookRepository) {
        self.repository = repository
    }
    
    func executeSaveFavorite(book: Book) -> Single<Void> {
        return repository.saveFavorite(book: book)
    }
    
    func executeSaveRecent(book: Book) -> Single<Void> {
        return repository.saveRecent(book: book)
    }
}
