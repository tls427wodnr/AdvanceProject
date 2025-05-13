//
//  BookSearchViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit
import RxSwift

enum BookSection: Int, CaseIterable {
    case recent
    case searchResult

    var headerTitle: String {
        switch self {
        case .recent: return "최근 본 책"
        case .searchResult: return "검색 결과"
        }
    }
}

final class BookSearchViewController: UIViewController, UISearchBarDelegate {
    private let bookSearchBar = BookSearchBar()
    
    private lazy var bookSearchResultCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(
            RecentBookCell.self,
            forCellWithReuseIdentifier: RecentBookCell.id
        )
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
    
    private let viewModel = BookSearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var favoriteBooks = [Book]()
    private var recentBooks = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupSearchBar()
        setupActions()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchRecentBooks()
        bookSearchResultCollectionView.reloadData()
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
            $0.top.equalTo(bookSearchBar.snp.bottom).offset(32)
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
    
    private func bindViewModel() {
        viewModel.bookSearchResultsSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.favoriteBooks = books
                self?.bookSearchResultCollectionView.reloadData()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
        
        viewModel.recentBooksSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.recentBooks = books
                self?.bookSearchResultCollectionView.reloadData()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    @objc private func cancelButtonDidTap() {
        bookSearchBar.searchBar.text = ""
        bookSearchBar.searchBar.resignFirstResponder()
        bookSearchBar.setCancelButtonVisible(false)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = BookSection(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .recent:
                return self.createRecentSection()
            case .searchResult:
                return self.createSearchResultSection()
            }
        }
    }
    
    private func createRecentSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60 * 5),
            heightDimension: .absolute(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 12, leading: 8, bottom: 28, trailing: 8)
        
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
        
        return section
    }
    
    private func createSearchResultSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
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
        
        return section
    }
    
    func focusSearchBar() {
        bookSearchBar.searchBar.becomeFirstResponder()
    }
}

extension BookSearchViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        bookSearchBar.setCancelButtonVisible(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchBooks(with: query)
        searchBar.resignFirstResponder()
        bookSearchBar.setCancelButtonVisible(false)
    }
}

extension BookSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return BookSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch BookSection(rawValue: section) {
        case .recent: return recentBooks.count
        case .searchResult: return favoriteBooks.count
        case .none: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = BookSection(rawValue: indexPath.section) else { return UICollectionViewCell() }

        switch section {
        case .recent:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecentBookCell.id,
                for: indexPath
            ) as! RecentBookCell
            cell.configure(with: recentBooks[indexPath.item].thumbnailURL)
            return cell

        case .searchResult:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchResultCell.id,
                for: indexPath
            ) as! SearchResultCell
            cell.configure(with: favoriteBooks[indexPath.item])
            return cell
        }
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
        
        if let section = BookSection(rawValue: indexPath.section) {
            switch section {
            case .recent:
                headerView.titleLabel.text = "최근 본 책"
            case .searchResult:
                headerView.titleLabel.text = "검색 결과"
            }
        }
        
        return headerView
    }
}

extension BookSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = BookSection(rawValue: indexPath.section) else { return }

        if section == .recent {
            return
        }
        
        let detailVC = BookDetailViewController(book: favoriteBooks[indexPath.item])
        detailVC.modalPresentationStyle = .pageSheet
        detailVC.onDismiss = { [weak detailVC, weak self] in
            guard let self else { return }
            self.viewModel.fetchRecentBooks()
            
            if detailVC?.wasBookSaved() == true {
                let alert = UIAlertController(title: "완료", message: "책이 저장되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        }
        present(detailVC, animated: true)
    }
}
