//
//  SearchViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {

    // MARK: - UI & Properties
    private let searchView = SearchView()
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    private var books: [Book] = []
    private var recentBooks: [RecentBook] = []
    weak var coordinator: SearchCoordinator?

    // MARK: - Init
    init(viewModel: SearchViewModel, coordinator: SearchCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        bind()
        viewModel.fetchRecentBooks()
    }

    // MARK: - Setup
    private func setupView() {
        searchView.searchBar.delegate = self

        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)

        searchView.recentBooksView.collectionView.delegate = self
        searchView.recentBooksView.collectionView.dataSource = self
        searchView.recentBooksView.collectionView.register(RecentBookCell.self, forCellWithReuseIdentifier: RecentBookCell.identifier)

        searchView.recentBooksView.onTapDelete = { [weak self] in
            self?.viewModel.deleteAllRecentBooks()
            self?.view.showToast(message: "최근 본 책 목록이 삭제되었습니다")
        }
    }

    private func setupNavigation() {
        title = "책 검색"
    }

    // MARK: - Bind
    private func bind() {
        // 검색 결과 바인딩
        viewModel.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books = books
                self?.searchView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        // 최근 본 책 바인딩
        viewModel.recentBooks
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] recent in
                self?.recentBooks = recent
                self?.searchView.recentBooksView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Public
    func focusSearchBar() {
        DispatchQueue.main.async {
            self.searchView.searchBar.becomeFirstResponder()
        }
    }
}


// MARK: - UISearchBarDelegate
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchQuery.onNext(query)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == searchView.collectionView {
            return books.count
        } else {
            return recentBooks.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == searchView.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as! BookCell
            cell.configure(with: books[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentBookCell.identifier, for: indexPath) as! RecentBookCell
            cell.configure(with: recentBooks[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == searchView.collectionView {
            let selectedBook = books[indexPath.item]
            viewModel.saveToRecent(book: selectedBook)
            coordinator?.showBookDetail(book: selectedBook)
        } else {
            let recent = recentBooks[indexPath.item]
            let book = recent.toBook()
            coordinator?.showBookDetail(book: book)
        }
    }
}
