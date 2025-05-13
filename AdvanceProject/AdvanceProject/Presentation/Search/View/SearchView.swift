//
//  SearchView.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit
import SnapKit
import Then

final class SearchView: UIView {

    enum LayoutType {
        case flow
        case compositional
    }

    let searchBar = UISearchBar().then {
        $0.placeholder = "책 제목을 검색하세요"
        $0.searchBarStyle = .minimal
        $0.returnKeyType = .search
        $0.autocapitalizationType = .none
    }

    let collectionView: UICollectionView = {
        let layout = makeLayout(.compositional)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(searchBar)
        addSubview(collectionView)

        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private static func makeLayout(_ type: LayoutType) -> UICollectionViewLayout {
        switch type {
        case .flow:
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
            layout.minimumLineSpacing = 12
            layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            return layout

        case .compositional:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)

            return UICollectionViewCompositionalLayout(section: section)
        }
    }
}


