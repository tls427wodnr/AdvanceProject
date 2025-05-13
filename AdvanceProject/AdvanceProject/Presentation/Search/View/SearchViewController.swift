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
    }

    // MARK: - Setup
    private func setupView() {
        searchView.searchBar.delegate = self
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
    }
    
    private func setupNavigation() {
        title = "책 검색"
    }

    // MARK: - Bind
    private func bind() {
        viewModel.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books = books
                self?.searchView.collectionView.reloadData()
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
        books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: books[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.item]
        coordinator?.showBookDetail(book: selectedBook)
    }
}
