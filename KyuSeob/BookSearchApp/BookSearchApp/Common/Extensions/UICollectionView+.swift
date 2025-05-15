//
//  UICollectionView+.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/14/25.
//

import UIKit

extension UICollectionView {
    static func withCompositionalLayout() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if let section = Section(sectionIndex) {
                return section.layoutSection
            }
            return nil
        }
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}
