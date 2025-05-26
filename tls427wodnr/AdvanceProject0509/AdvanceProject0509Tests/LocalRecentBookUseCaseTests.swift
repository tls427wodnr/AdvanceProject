//
//  LocalRecentBookUseCaseTests.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/26/25.
//

import XCTest
import RxSwift
import RxBlocking
@testable import AdvanceProject0509

final class LocalRecentBookUseCaseTests: XCTestCase {

    // MARK: - Mock Repository

    final class MockRecentBookRepository: LocalRecentBookRepositoryProtocol {
        var savedBooks: [BookItem] = []
        var loadCalled = false

        func load() -> Single<[BookItem]> {
            loadCalled = true
            return .just(savedBooks)
        }

        func save(_ book: BookItem) -> Completable {
            savedBooks.append(book)
            return .empty()
        }
    }

    // MARK: - Properties

    var mockRepository: MockRecentBookRepository!
    var useCase: LocalRecentBookUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockRecentBookRepository()
        useCase = LocalRecentBookUseCase(repository: mockRepository)
    }

    // MARK: - Tests

    func test_loadRecentBooks_returnsSavedBooks() {
        // Given
        let book = BookItem(
            isbn: "001",
            title: "Swift Basics",
            image: "img",
            author: "Apple",
            publisher: "Apple",
            description: "Basics of Swift"
        )
        mockRepository.savedBooks = [book]

        // When
        let result = try? useCase.loadRecentBooks().toBlocking(timeout: 1.0).first()

        // Then
        XCTAssertTrue(mockRepository.loadCalled)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.isbn, "001")
    }

    func test_addRecentBook_savesBookToRepository() {
        // Given
        let book = BookItem(
            isbn: "002",
            title: "RxSwift",
            image: "img",
            author: "Rx",
            publisher: "RxOrg",
            description: "Reactive programming"
        )

        // When
        let result = useCase.addRecentBook(book).toBlocking(timeout: 1.0).materialize()

        switch result {
        case .completed:
            XCTAssertTrue(true) // 통과
        case .failed(_, let error):
            XCTFail("Expected completed, but failed with error: \(error)")
        }
        
        // Then
        XCTAssertEqual(mockRepository.savedBooks.count, 1)
        XCTAssertEqual(mockRepository.savedBooks.first?.isbn, "002")
    }
}
