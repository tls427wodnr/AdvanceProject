//
//  RecentBookManager.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import Foundation
import RxSwift

final class RecentBookDataManager {
    
    static let shared = RecentBookDataManager()
    
    private let key = "recentBooks"
    private let maxCount = 10

    func load() -> Single<[BookItem]> {
        return Single.create { single in
            guard let data = UserDefaults.standard.data(forKey: self.key),
                  let books = try? JSONDecoder().decode([BookItem].self, from: data) else {
                single(.success([]))
                return Disposables.create()
            }
            single(.success(books))
            return Disposables.create()
        }
    }

    func save(_ book: BookItem) -> Completable {
        return Completable.create { completable in
            var books = self.loadSync()
            books.removeAll { $0.isbn == book.isbn }
            books.insert(book, at: 0)
            if books.count > self.maxCount {
                books = Array(books.prefix(self.maxCount))
            }

            do {
                let data = try JSONEncoder().encode(books)
                UserDefaults.standard.set(data, forKey: self.key)
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    private func loadSync() -> [BookItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let books = try? JSONDecoder().decode([BookItem].self, from: data) else {
            return []
        }
        return books
    }
}
