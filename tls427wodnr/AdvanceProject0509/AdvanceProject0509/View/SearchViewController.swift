//
//  SearchViewController.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: UIViewController {
    
    // MARK: - UI
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 제목을 검색하세요"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.register(RecentBookCollectionViewCell.self, forCellWithReuseIdentifier: RecentBookCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionHeaderView")
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let searchViewModel = SearchViewModel()
    private let recentViewModel = RecentBookListViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<BookSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let section = dataSource[indexPath.section]
            switch section {
            case .recent:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBookCollectionViewCell.identifier, for: indexPath) as! RecentBookCollectionViewCell
                cell.configure(with: item.image)
                return cell
                
            case .search:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
                cell.configure(with: item)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "SectionHeaderView",
                for: indexPath
            ) as! SectionHeaderView
            
            switch dataSource[indexPath.section] {
            case .recent:
                header.setTitle("최근 본 책")
            case .search:
                header.setTitle("검색 결과")
            }
            return header
        }
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        bindFocusTrigger()
    }
    
    private func setupUI() {
        title = "도서 검색"
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Bindings
    
    private func bindFocusTrigger() {
        SearchFocusEvent.shared.focusTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.searchBar.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        
        let searchInput = SearchViewModel.Input(
            query: searchBar.rx.text.orEmpty
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
        )
        
        let searchOutput = searchViewModel.transform(input: searchInput)
        
        let recentInput = RecentBookListViewModel.Input(
            loadTrigger: .just(()),
            addBook: collectionView.rx.modelSelected(BookItem.self).asObservable()
        )
        let recentOutput = recentViewModel.transform(input: recentInput)
        
        Observable.combineLatest(recentOutput.books.asObservable(), searchOutput.books.asObservable())
            .map { recent, search -> [BookSection] in
                var sections: [BookSection] = []
                if !recent.isEmpty {
                    sections.append(.recent(recent))
                }
                if !search.isEmpty {
                    sections.append(.search(search))
                }
                return sections
            }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        searchOutput.error
            .emit(onNext: { [weak self] error in
                let alert = UIAlertController(
                    title: "에러",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(BookItem.self)
            .subscribe(onNext: { book in
                let bottomSheetVC = BookDetailBottomSheetViewController()
                bottomSheetVC.configure(with: book)
                bottomSheetVC.modalPresentationStyle = .pageSheet
                
                if let sheet = bottomSheetVC.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.selectedDetentIdentifier = .large
                    sheet.prefersGrabberVisible = true
                }
                
                self.present(bottomSheetVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case 0: return self.createRecentBooksSectionLayout()
            case 1: return self.createSearchResultsSectionLayout()
            default: return nil
            }
        }
    }
    
    private func createRecentBooksSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .absolute(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
    private func createSearchResultsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(40)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        
        return section
    }
    
}
