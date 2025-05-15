//
//  SearchView.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit
import SnapKit

enum Section: Int {
    case history
    case searchResult
    
    var title: String {
        switch self {
        case .history:
            return "최근 본 책"
        case .searchResult:
            return "검색 결과"
        }
    }
}

class SearchView: UIView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionViewLayout()
        )
        // "최근 본 책" 셀
        collectionView.register(
            HistoryCell.self,
            forCellWithReuseIdentifier: HistoryCell.reuseIdentifier
        )
        // "검색 결과" 셀
        collectionView.register(
            SearchResultCell.self,
            forCellWithReuseIdentifier: SearchResultCell.reuseIdentifier
        )
        // 헤더 뷰
        collectionView.register(
            SearchHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchHeader.reuseIdentifier
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        [searchBar, collectionView].forEach { addSubview($0) }
        
        setConstraints()
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    // 섹션 별 전체 레이아웃
    private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            let section = Section(rawValue: index)!
            switch section {
            case .history:
                return self?.makeHistoryLayoutSection()
            case .searchResult:
                return self?.makeSearchResultLayoutSection()
            }
        }
        
        return layout
    }
    
    // "최근 본 책" 섹션 레이아웃
    private func makeHistoryLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(110),
                                               heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    // "검색 결과" 섹션 레이아웃
    private func makeSearchResultLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
