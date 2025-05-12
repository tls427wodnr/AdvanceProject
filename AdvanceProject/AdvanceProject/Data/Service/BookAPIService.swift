//
//  BookAPIService.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/11/25.
//

import Foundation
import RxSwift

final class BookAPIService {

    private var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String else {
            fatalError("KAKAO_REST_API_KEY가 Info.plist에 설정되지 않았습니다.")
        }
        return "KakaoAK \(key)"
    }

    func searchBooks(query: String) -> Single<[BookDTO]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(NSError(domain: "BookAPIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self deallocated"])))
                return Disposables.create()
            }

            var components = URLComponents(string: "https://dapi.kakao.com/v3/search/book")!
            components.queryItems = [URLQueryItem(name: "query", value: query)]

            var request = URLRequest(url: components.url!)
            request.setValue(self.apiKey, forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                guard let data = data else {
                    single(.failure(NSError(domain: "BookAPIService", code: -2, userInfo: [NSLocalizedDescriptionKey: "데이터 없음"])))
                    return
                }

                do {
                    let result = try JSONDecoder().decode(BookSearchResponseDTO.self, from: data)
                    single(.success(result.documents))
                } catch {
                    single(.failure(error))
                }
            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
    }
}
