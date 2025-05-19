//
//  CartBookRepository.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation
import CoreData

final class CartBookRepository: CartBookRepositoryProtocol {
    private let coreDataStorage: CoreDataStorageProtocol

    init(coreDataStorage: CoreDataStorageProtocol) {
        self.coreDataStorage = coreDataStorage
    }

    func addCartBook(book: Book) throws {
        let context = coreDataStorage.viewContext
        guard let bookEntityDescription = NSEntityDescription.entity(forEntityName: "BookEntity", in: context) else {
            fatalError("BookEntity EntityDescription not found")
        }
        let bookEntity = BookEntity(entity: bookEntityDescription, insertInto: context)
        bookEntity.configure(from: book)

        guard let cartBookEntityDescription = NSEntityDescription.entity(forEntityName: "CartBookEntity", in: context) else {
            fatalError("CartBookEntity EntityDescription not found")
        }
        let cartBookEntity = CartBookEntity(entity: cartBookEntityDescription, insertInto: context)
        cartBookEntity.configure(book: bookEntity)

        try coreDataStorage.saveContext(context)
    }

//    func addCartBook(book: Book) throws {
//        let context = coreDataStorage.viewContext
//
//        let modelURL = Bundle.main.url(forResource: "BookSearchModel", withExtension: "momd")
//        print("🔍 CoreData model URL: \(modelURL?.absoluteString ?? "nil")")
//        let bookEntity = BookEntity(context: context)
//        bookEntity.configure(from: book)
//
//        let cartBookEntity = CartBookEntity(context: context)
//        cartBookEntity.configure(book: bookEntity)
//
//        try coreDataStorage.saveContext(context)
//    }

    func fetchCartBooks() throws -> [CartBook] {
        // 타입캐스팅하지 않으면 <NSFetchRequestResult>로 에러 발생.
        let request = NSFetchRequest<CartBookEntity>(entityName: "CartBookEntity")
        let cartBookEntities = try coreDataStorage.fetch(request)
        let cartBooks: [CartBook] = cartBookEntities.map { entity in
            let cartBook = CartBook(
                book: Book(
                    isbn: entity.book.isbn ?? "",
                    title: entity.book.title ?? "",
                    authors: entity.book.authors ?? [],
                    thumbnail: entity.book.thumbnail ?? "",
                    price: Int(entity.book.price),
                    contents: entity.book.contents ?? ""
                ),
                createdAt: entity.createdAt
            )
            return cartBook
        }
        return cartBooks
    }

    func deleteAllCartBooks() throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CartBookEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        try coreDataStorage.batchDelete(deleteRequest, in: coreDataStorage.viewContext)
    }

    func deleteCartBook(createdAt: Date) throws {
        let context = coreDataStorage.viewContext
        let request = NSFetchRequest<CartBookEntity>(entityName: "CartBookEntity")
        request.predicate = NSPredicate(format: "createdAt == %@", createdAt as NSDate)

        let matchedItems = try context.fetch(request)

        guard let target = matchedItems.first else {
            throw CoreDataError.custom("삭제하려는 책이 이미 담은 리스트에 존재하지 않습니다.")
        }

        try coreDataStorage.delete(target, in: context)

        try coreDataStorage.saveContext(context)
    }
}
