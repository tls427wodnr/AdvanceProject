//
//  CoreDataError.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation

enum CoreDataError: Error {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    case custom(String)
}
