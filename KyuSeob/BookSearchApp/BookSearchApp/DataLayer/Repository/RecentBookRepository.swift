//
//  RecentBookRepository.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/14/25.
//

import Foundation
import CoreData

final class RecentBookRepository: RecentBookRepositoryProtocol {
    private let coreDataStorage: CoreDataStorageProtocol

    init(coreDataStorage: CoreDataStorageProtocol) {
        self.coreDataStorage = coreDataStorage
    }

    func createOrUpdateRecentBook(for book: Book, in context: NSManagedObjectContext) throws {
        let fetchBook = NSFetchRequest<BookEntity>(entityName: "BookEntity")
        fetchBook.predicate = NSPredicate(format: "isbn == %@", book.isbn)

        let bookEntity: BookEntity
        if let existing = try context.fetch(fetchBook).first {
            bookEntity = existing
        } else {
            guard let bookEntityDescription = NSEntityDescription.entity(forEntityName: "BookEntity", in: context) else {
                fatalError("BookEntity EntityDescription not found")
            }
            bookEntity = BookEntity(entity: bookEntityDescription, insertInto: context)
            bookEntity.configure(from: book)
        }

        let fetchRecent = NSFetchRequest<RecentBookEntity>(entityName: "RecentBookEntity")
        fetchRecent.predicate = NSPredicate(format: "book == %@", bookEntity)

        let recentBookEntity: RecentBookEntity
        if let existingRecent = try context.fetch(fetchRecent).first {
            recentBookEntity = existingRecent
            recentBookEntity.lastViewedAt = Date()
        } else {
            guard let recentBookEntityDescription = NSEntityDescription.entity(forEntityName: "RecentBookEntity", in: context) else {
                fatalError("RecentBookEntity EntityDescription not found")
            }
            let recentBookEntity = RecentBookEntity(entity: recentBookEntityDescription, insertInto: context)
            recentBookEntity.configure(book: bookEntity)
        }
    }

    func fetchSortedRecentBookEntities(toPresent: Bool) throws -> [RecentBookEntity] { // toList가 가공 목적일 땐 false, UI에 보여줄 목적일 땐 true
        let request = NSFetchRequest<RecentBookEntity>(entityName: "RecentBookEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "lastViewedAt", ascending: false)]
        request.fetchLimit = toPresent ? 10 : .max
        let recentBookEntities = try coreDataStorage.fetch(request)

        return recentBookEntities
    }

    func fetchSortedRecentBooks() throws -> [RecentBook] { // toList가 가공 목적일 땐 false, UI에 보여줄 목적일 땐 true
        let entities = try fetchSortedRecentBookEntities(toPresent: true)
        return entities.map { $0.toDomain() }
    }

    func trimRecentBooks(from entities: [RecentBookEntity], in context: NSManagedObjectContext) throws {
        guard entities.count > 10 else { return }

        let toDeletes = entities[10...]
        for i in toDeletes {
            try coreDataStorage.delete(i, in: context)
        }
    }

    func addAndFetchRecentBookList(book: Book) throws { // 기능 상 최근 본 책을 추가하기만 한다면 최신 10개가 아닌 경우 dummy가 됨.
        let context = coreDataStorage.viewContext

        try createOrUpdateRecentBook(for: book, in: context)

        let entities = try fetchSortedRecentBookEntities(toPresent: false)

        try trimRecentBooks(from: entities, in: context)

        try coreDataStorage.saveContext(context)
    }


}
