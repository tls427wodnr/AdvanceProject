//
//  MainViewController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxSwift
import SnapKit
import Then
import RxDataSources

class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let diContainer: DIContainer
    private let disposeBag = DisposeBag()

    private let searchBar = UISearchBar().then {
        $0.placeholder = "책 제목을 입력해주세요"
        $0.searchBarStyle = .minimal
        $0.backgroundColor = .systemBackground
    }

    private lazy var resultCollectionView: UICollectionView = {
        let collectionView = UICollectionView.withCompositionalLayout()
        collectionView.register(
            SearchResultCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier
        )
        collectionView.register(
            RecentBookCollectionViewCell.self,
            forCellWithReuseIdentifier: RecentBookCollectionViewCell.identifier
        )
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )

        return collectionView
    }()

    typealias BookSectionDataSource = RxCollectionViewSectionedReloadDataSource<BookSection>

    let dataSource = BookSectionDataSource (
        configureCell: {_, collectionView, indexPath, item in
            print("📦 section[\(indexPath.section)] item[\(indexPath.item)] = \(item)")
            switch item {
            case .recent(let recentBook):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RecentBookCollectionViewCell.identifier,
                    for: indexPath
                ) as? RecentBookCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: recentBook.book.thumbnail)
                return cell
            case .search(let book):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchResultCollectionViewCell.identifier,
                    for: indexPath
                ) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(book: book)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath
            ) as? SectionHeaderView else { return UICollectionReusableView() }

            let title: String
            switch dataSource.sectionModels[indexPath.section] {
            case .recent: title = "최근 본 책"
            case .search: title = "검색 결과"
            }
            header.configure(with: title)
            return header
        }
    )

    private lazy var recentEmptyView = EmptyView().then {
        $0.configure(with: "최근 본 책이 없어요")
    }

    private lazy var searchEmptyView = EmptyView().then {
        $0.configure(with: "검색 결과가 없어요")
    }

    init(viewModel: MainViewModel, diContainer: DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchRecentBooks
            .accept(())
    }

    func activateSearchBar() {
        searchBar.becomeFirstResponder()
    }
}

private extension MainViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground
        searchBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
    }

    func setHierarchy() {
        view.addSubviews(views: searchBar, resultCollectionView, recentEmptyView, searchEmptyView)
    }

    func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(44)
        }

        resultCollectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }

        recentEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(54)
            $0.directionalHorizontalEdges.equalTo(resultCollectionView)
            $0.height.equalTo(120)
        }

        searchEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(174) // 첫번째 섹션 높이만큼 띄움
            $0.directionalHorizontalEdges.equalTo(resultCollectionView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func bind() {
        searchBar.rx.searchButtonClicked
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(onNext: { [weak self] query in
                guard let self else { return }
                self.viewModel.searchBooks(with: query, of: 1) // TODO: - Rx 방식으로 변경
            }).disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .bind(onNext: { [weak self] text in
                guard let self else { return }
                if text.isEmpty {
                    self.viewModel.searchBooks(with: text, of: 1)
                }
            }).disposed(by: disposeBag)

        resultCollectionView.rx.contentOffset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] offset in
                guard let self else { return }

                let contentHeight = self.resultCollectionView.contentSize.height
                let visibleHeight = self.resultCollectionView.frame.height
                let yOffset = offset.y

                if yOffset > contentHeight - visibleHeight - 100 {
                    self.viewModel.searchTrigger.accept(())
                }
            }).disposed(by: disposeBag)

        viewModel.searchResultBooks
            .subscribe(onNext: { [weak self] books in
                guard let self else { return }
                searchEmptyView.isHidden = !books.isEmpty
            }).disposed(by: disposeBag)

        viewModel.recentBooks
            .subscribe(onNext: { [weak self] books in
                guard let self else { return }
                recentEmptyView.isHidden = !books.isEmpty
            }).disposed(by: disposeBag)

        viewModel.didFailedEvent
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                self.showNoticeAlert(message: error.localizedDescription) // TODO: - 에러 메시지 정의
            }).disposed(by: disposeBag)

        viewModel.sections
            .bind(to: resultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        resultCollectionView.rx.modelSelected(BookSectionItem.self)
            .subscribe(
                onNext: { [weak self] item in
                    guard let self else { return }
                    let book: Book

                    switch item {
                    case .search(let searchBook):
                        book = searchBook
                    case .recent(let recentBook):
                        book = recentBook.book
                    }

                    let (detailVC, detailVM) = diContainer.makeBookDetailViewController(book: book)
                    detailVM.detailViewDismissed
                        .subscribe(onNext: { [weak self] in
                            guard let self else { return }
                            self.viewModel.fetchRecentBooks.accept(())
                        }).disposed(by: disposeBag)
                    detailVC.modalPresentationStyle = .pageSheet
                    self.present(detailVC, animated: true)
                }).disposed(by: disposeBag)
    }

}
