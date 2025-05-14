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
    
    let recentBooksView = RecentBooksView()

    let searchBar = UISearchBar().then {
        $0.placeholder = "책 제목을 검색하세요"
        $0.searchBarStyle = .minimal
        $0.returnKeyType = .search
        $0.autocapitalizationType = .none
    }
    
    private let searchResultTitleLabel = UILabel().then {
        $0.text = "검색 목록"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .label
    }

    let collectionView: UICollectionView = {
        let layout = makeLayout()
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
        addSubview(recentBooksView)
        addSubview(searchResultTitleLabel)
        addSubview(collectionView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        recentBooksView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        searchResultTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recentBooksView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchResultTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private static func makeLayout() -> UICollectionViewLayout {
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



