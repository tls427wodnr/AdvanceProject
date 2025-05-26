//
//  LocalBookUseCaseTests.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/26/25.
//

import XCTest
import RxSwift
import RxBlocking
@testable import AdvanceProject0509

final class LocalBookUseCaseTests: XCTestCase {

    // MARK: - Mock Repository

    final class MockLocalBookRepository: LocalBookRepositoryProtocol {
        var savedItems: [BookItem] = []
        var fetchAllCalled = false
        var deleteCalledWithISBN: String?
        var deleteAllCalled = false

        func save(_ item: BookItem) -> Completable {
            savedItems.append(item)
            return .empty()
        }

        func fetchAll() -> Single<[BookItem]> {
            fetchAllCalled = true
            return .just(savedItems)
        }

        func delete(isbn: String) -> Completable {
            deleteCalledWithISBN = isbn
            return .empty()
        }

        func deleteAll() -> Completable {
            deleteAllCalled = true
            return .empty()
        }
    }

    // MARK: - Setup

    var mockRepository: MockLocalBookRepository!
    var useCase: LocalBookUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockLocalBookRepository()
        useCase = LocalBookUseCase(repository: mockRepository)
    }

    // MARK: - Tests

    func test_save_savesBookItem() {
        let book = BookItem(isbn: "123", title: "Swift", image: "", author: "Apple", publisher: "Apple", description: "Desc")

        XCTAssertNoThrow(useCase.save(book).toBlocking(timeout: 1.0).materialize())

        XCTAssertEqual(mockRepository.savedItems.count, 1)
        XCTAssertEqual(mockRepository.savedItems.first?.isbn, "123")
    }

    func test_fetchAll_returnsSavedItems() {
        let book = BookItem(isbn: "123", title: "Swift", image: "", author: "Apple", publisher: "Apple", description: "Desc")
        mockRepository.savedItems = [book]

        let result = try? useCase.fetchAll().toBlocking(timeout: 1.0).first()

        XCTAssertTrue(mockRepository.fetchAllCalled)
        XCTAssertEqual(result?.first?.title, "Swift")
    }

    func test_delete_removesBookByISBN() {
        XCTAssertNoThrow(useCase.delete(isbn: "123").toBlocking(timeout: 1.0).materialize())

        XCTAssertEqual(mockRepository.deleteCalledWithISBN, "123")
    }

    func test_deleteAll_clearsAllBooks() {
        XCTAssertNoThrow(useCase.deleteAll().toBlocking(timeout: 1.0).materialize())

        XCTAssertTrue(mockRepository.deleteAllCalled)
    }
}
