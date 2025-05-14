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

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ viewController: UIViewController, didSelect book: BookItem)
}

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
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.register(RecentBookCollectionViewCell.self, forCellWithReuseIdentifier: RecentBookCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionHeaderView")
        return collectionView
    }()
    
    // MARK: - Properties
    
    weak var delegate: SearchViewControllerDelegate?
    
    private let searchViewModel: SearchViewModelProtocol
    private let recentViewModel: RecentBookListViewModelProtocol
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
                cell.configure(with: item)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
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
    
    init(searchViewModel: SearchViewModelProtocol, recentViewModel: RecentBookListViewModelProtocol) {
        self.searchViewModel = searchViewModel
        self.recentViewModel = recentViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    // MARK: - Input Builders
    
    private func makeQueryInput() -> Observable<String> {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    private func makeLoadMoreTrigger() -> Observable<Void> {
        collectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }

                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
                guard let lastVisible = visibleIndexPaths.sorted().last,
                      case .search = self.dataSource[lastVisible.section] else {
                    return false
                }

                let offsetY = self.collectionView.contentOffset.y
                let contentHeight = self.collectionView.contentSize.height
                let frameHeight = self.collectionView.frame.size.height

                return offsetY > (contentHeight - frameHeight - 150)
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
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
        
        let searchInput = SearchViewModelInput(
            query: makeQueryInput(),
            loadMoreTrigger: makeLoadMoreTrigger()
        )
        
        let searchOutput = searchViewModel.transform(input: searchInput)
        
        let bookSelection = collectionView.rx.itemSelected
            .withLatestFrom(collectionView.rx.modelSelected(BookItem.self)) { ($0, $1) }
            .filter { [weak self] indexPath, _ in
                guard let self = self else { return false }
                return {
                    if case .search = self.dataSource[indexPath.section] {
                        return true
                    }
                    return false
                }()
            }
            .map { $0.1 }
        
        let recentInput = RecentBookListViewModelInput(
            loadTrigger: .just(()),
            addBook: bookSelection.asObservable()
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
            .subscribe(onNext: { [weak self] book in
                guard let self = self else { return }
                self.delegate?.searchViewController(self, didSelect: book)
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
