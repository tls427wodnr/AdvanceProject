//
//  SearchBookRepositoryProtocol.swift
//  Book
//
//  Created by 권순욱 on 5/15/25.
//

import Foundation
import RxSwift

public protocol SearchBookRepositoryProtocol {
    // 무한 스크롤 구현 전: book 데이터만 수신, page 쿼리 불가
    func searchBook(searchText: String, completion: @escaping (Result<[Book], Error>) -> Void)
    // 무한 스크롤 구현 후: book 데이터와 meta 데이터 수신, page 쿼리 가능, RxSwift 이용
    func searchBook(searchText: String, page: Int) -> Single<(books: [Book], meta: Meta)>
}
