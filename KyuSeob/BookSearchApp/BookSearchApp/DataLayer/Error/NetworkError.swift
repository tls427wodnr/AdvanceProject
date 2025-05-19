//
//  NetworkError.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "요청 주소가 올바르지 않습니다. 관리자에게 문의해주세요."
        case .noData:
            return "서버로부터 데이터를 받지 못했습니다. 잠시 후 다시 시도해주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
