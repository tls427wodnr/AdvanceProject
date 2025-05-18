//
//  BookSearchViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

enum BookSectionType {
    case recent
    case searchResult
}

struct BookSectionModel {
    let type: BookSectionType
    var header: String
    var items: [Book]
}

extension BookSectionModel: SectionModelType {
    init(original: BookSectionModel, items: [Book]) {
        self = original
        self.items = items
    }
}

final class BookSearchViewController: UIViewController {
    private let bookSearchBar = BookSearchBar()
    
    private let searchTriggerRelay = PublishRelay<String>()
    private let reachedBottomRelay = PublishRelay<Void>()
    
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
        return cv
    }()
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<BookSectionModel>(
        configureCell: { dataSource, collectionView, indexPath, book in
            let sectionType = dataSource.sectionModels[indexPath.section].type
            switch sectionType {
            case .recent:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecentBookCell.id,
                    for: indexPath
                ) as! RecentBookCell
                cell.configure(with: book.thumbnailURL)
                return cell
            case .searchResult:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchResultCell.id,
                    for: indexPath
                ) as! SearchResultCell
                cell.configure(with: book)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.id,
                for: indexPath
            ) as? SectionHeaderView else {
                return UICollectionReusableView()
            }
            headerView.titleLabel.text = dataSource.sectionModels[indexPath.section].header
            return headerView
        }
    )
    
    private let viewModel: BookSearchViewModel = {
        let repository = BookRepositoryImpl()
        let useCase = DefaultBookSearchUseCase(repository: repository)
        return BookSearchViewModel(bookSearchUseCase: useCase)
    }()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = BookSearchViewModel.Input(
            searchTrigger: searchTriggerRelay.asObservable(),
            reachedBottomTrigger: reachedBottomRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        setupViews()
        setupConstraints()
        bindSectionedBooks(with: output)
        bindSearchBar()
        bindBookSelection()
        bindPagination()
        bindCancelButton()
        bindErrorMessage(with: output)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchRecentBooks()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [
            bookSearchBar,
            bookSearchResultCollectionView
        ].forEach { view.addSubview($0) }
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
    
    private func bindSectionedBooks(with output: BookSearchViewModel.Output) {
        output.sectionedBooks
            .drive(bookSearchResultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        bookSearchBar.searchBar.rx.searchButtonClicked
            .withLatestFrom(bookSearchBar.searchBar.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .bind(onNext: { [weak self] query in
                self?.searchTriggerRelay.accept(query)
                self?.bookSearchBar.searchBar.resignFirstResponder()
                self?.bookSearchBar.setCancelButtonVisible(false)
            })
            .disposed(by: disposeBag)
        
        bookSearchBar.searchBar.rx.textDidBeginEditing
            .bind(onNext: { [weak self] in
                self?.bookSearchBar.setCancelButtonVisible(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBookSelection() {
        bookSearchResultCollectionView.rx
            .modelSelected(Book.self)
            .bind(onNext: { [weak self] selectedBook in
                guard let self else { return }
                
                let detailVC = BookDetailViewController(book: selectedBook)
                detailVC.modalPresentationStyle = .pageSheet
                detailVC.onDismiss = { [weak detailVC] in
                    self.viewModel.fetchRecentBooks()
                    if detailVC?.wasBookSaved() == true {
                        let alert = UIAlertController(title: "완료", message: "책이 저장되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(alert, animated: true)
                    }
                }
                present(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindPagination() {
        bookSearchResultCollectionView.rx
            .willDisplayCell
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self else { return }
                
                let sectionType = self.dataSource.sectionModels[indexPath.section].type
                guard sectionType == .searchResult else { return }
                
                let itemCount = self.dataSource.sectionModels[indexPath.section].items.count
                if indexPath.item >= itemCount - 3 {
                    self.reachedBottomRelay.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCancelButton() {
        bookSearchBar.cancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.bookSearchBar.searchBar.text = ""
                self?.bookSearchBar.searchBar.resignFirstResponder()
                self?.bookSearchBar.setCancelButtonVisible(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindErrorMessage(with output: BookSearchViewModel.Output) {
        output.errorMessage
            .emit(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
                
            let sectionType = self.dataSource.sectionModels[sectionIndex].type
            
            switch sectionType {
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
            heightDimension: .absolute(40)
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

extension BookSearchViewController: ScrollToTopCapable {
    func scrollToTop() {
        let offset = CGPoint(x: 0, y: -bookSearchResultCollectionView.contentInset.top)
        bookSearchResultCollectionView.setContentOffset(offset, animated: true)
    }
}

extension UIViewController {
    func showAlert(
        title: String = "알림",
        message: String,
        buttonTitle: String = "확인",
        handler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            handler?()
        })
        present(alert, animated: true)
    }
}
