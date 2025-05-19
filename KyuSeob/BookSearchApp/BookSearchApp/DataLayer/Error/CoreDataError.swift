//
//  CoreDataError.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import Foundation

enum CoreDataError: LocalizedError {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .saveError:
            return "데이터를 저장하는 중 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .fetchError:
            return "저장된 데이터를 불러오는 데 문제가 발생했습니다. 앱을 다시 실행해주세요."
        case .deleteError:
            return "데이터를 삭제하는 중 오류가 발생했습니다. 다시 시도해주세요."
        case .custom(let message):
            return message
        }
    }
}
