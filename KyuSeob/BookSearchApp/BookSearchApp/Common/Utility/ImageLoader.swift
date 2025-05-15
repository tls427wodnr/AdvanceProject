//
//  ImageLoader.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/12/25.
//

import UIKit
import RxSwift

final class ImageLoader {
    static let shared = ImageLoader()

    func load(from url: String) -> Single<UIImage?> {
        return Single<UIImage?>.create { single in
            guard let url = URL(string: url) else {
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error {
                    single(.failure(error))
                    return
                }

                let image = data.flatMap { UIImage(data: $0) }
                single(.success(image))
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
