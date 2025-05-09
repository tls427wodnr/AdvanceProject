//
//  BookSearchViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

let dummyBooks: [Book] = [
    Book(title: "미움받을 용기", authors: "기시미 이치로, 고가 후미타케", salePrice: "13,410원", thumbnailURL: "https://example.com/image1.jpg", contents: "아들러 심리학을 쉽고 맛있게 풀어낸 대화체 철학서"),
    Book(title: "죽음의 수용소에서", authors: "빅터 프랭클", salePrice: "12,600원", thumbnailURL: "https://example.com/image2.jpg", contents: "아우슈비츠 생존자가 말하는 인간의 의미"),
    Book(title: "총, 균, 쇠", authors: "재레드 다이아몬드", salePrice: "18,000원", thumbnailURL: "https://example.com/image3.jpg", contents: "인류 문명의 기원과 발전을 설명한 역사서"),
    Book(title: "멋진 신세계", authors: "올더스 헉슬리", salePrice: "9,800원", thumbnailURL: "https://example.com/image4.jpg", contents: "디스토피아 사회를 그린 고전 소설"),
    Book(title: "자기 결정 이론", authors: "에드워드 데시", salePrice: "15,500원", thumbnailURL: "https://example.com/image5.jpg", contents: "동기와 자율성에 대한 심리학적 고찰"),
    Book(title: "습관의 힘", authors: "찰스 두히그", salePrice: "14,200원", thumbnailURL: "https://example.com/image6.jpg", contents: "작은 습관이 큰 변화를 만드는 원리"),
    Book(title: "나는 나로 살기로 했다", authors: "김수현", salePrice: "13,000원", thumbnailURL: "https://example.com/image7.jpg", contents: "타인의 시선에서 벗어나 자기답게 사는 법"),
    Book(title: "아몬드", authors: "손원평", salePrice: "11,700원", thumbnailURL: "https://example.com/image8.jpg", contents: "감정을 느끼지 못하는 소년의 성장 이야기"),
    Book(title: "해리 포터와 마법사의 돌", authors: "J.K. 롤링", salePrice: "10,500원", thumbnailURL: "https://example.com/image9.jpg", contents: "마법 세계로 들어간 소년의 첫 모험"),
    Book(title: "어린 왕자", authors: "앙투안 드 생텍쥐페리", salePrice: "8,500원", thumbnailURL: "https://example.com/image10.jpg", contents: "어른들을 위한 동화, 삶의 본질을 묻다")
]

final class BookSearchViewController: UIViewController, UISearchBarDelegate {
    private let bookSearchBar = BookSearchBar()
    
    private lazy var bookSearchResultCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(
            SearchResultCell.self,
            forCellWithReuseIdentifier: SearchResultCell.id
        )
        cv.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.id
        )
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupSearchBar()
        setupActions()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [
            bookSearchBar,
            bookSearchResultCollectionView
        ].forEach { view.addSubview($0) }
        
        bookSearchBar.setCancelButtonVisible(false)
    }
    
    private func setupConstraints() {
        bookSearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view).inset(16)
            $0.height.equalTo(56)
        }
        
        bookSearchResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(bookSearchBar.snp.bottom)
            $0.leading.trailing.equalTo(view).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupSearchBar() {
        bookSearchBar.searchBar.delegate = self
    }
    
    private func setupActions() {
        bookSearchBar.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func cancelButtonDidTap() {
        bookSearchBar.searchBar.text = ""
        bookSearchBar.searchBar.resignFirstResponder()
        bookSearchBar.setCancelButtonVisible(false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(48)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension BookSearchViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        bookSearchBar.setCancelButtonVisible(true)
    }
}

extension BookSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultCell.id,
            for: indexPath
        ) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: dummyBooks[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.id,
            for: indexPath
        ) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.titleLabel.text = "검색 결과"
        
        return headerView
    }
}

extension BookSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = BookDetailViewController(book: dummyBooks[indexPath.item])
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
}
