//
//  FetchBooksUseCaseTests.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/26/25.
//

import XCTest
import RxSwift
import RxBlocking
@testable import AdvanceProject0509

final class FetchBooksUseCaseTests: XCTestCase {

    // MARK: - Mock Repository

    final class MockBookRepository: BookRepositoryProtocol {
        var dummyBooks: [BookItem] = []

        func fetchBooks(query: String, start: Int) -> Observable<[BookItem]> {
            return Observable.just(dummyBooks)
        }
    }

    // MARK: - Tests

    func test_execute_returnsBookItems() throws {
        // Given
        let dummyBooks = [
            BookItem(
                isbn: "123",
                title: "Swift Programming",
                image: "https://example.com/swift.png",
                author: "Apple",
                publisher: "Apple Inc.",
                description: "Learn Swift from Apple"
            ),
            BookItem(
                isbn: "456",
                title: "RxSwift Guide",
                image: "https://example.com/rxswift.png",
                author: "ReactiveX",
                publisher: "ReactiveX Org",
                description: "Master RxSwift"
            )
        ]
        let mockRepository = MockBookRepository()
        mockRepository.dummyBooks = dummyBooks
        let useCase = FetchBooksUseCase(repository: mockRepository)

        // When
        let result = try useCase.execute(query: "Swift", start: 0)
            .toBlocking(timeout: 1.0)
            .first()

        // Then
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?.first?.title, "Swift Programming")
        XCTAssertEqual(result?.last?.author, "ReactiveX")
    }
}
