//
//  BookSearchResponseDTO.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

// MARK: - 전체 응답 DTO
struct BookSearchResponseDTO: Decodable {
    let meta: MetaDTO
    let documents: [BookDTO]
}

