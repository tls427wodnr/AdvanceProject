//
//  BookSearchRepositoryProtocol.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation
import RxSwift

protocol BookRepositoryProtocol: AnyObject {
    func searchBooks(query: String) -> Single<[Book]>
}
