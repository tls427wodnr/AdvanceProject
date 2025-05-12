//
//  SearchViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {
    
    private let mainView = SearchView()
    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    private var books: [Book] = []
    
    weak var coordinator: SearchCoordinator?
    
    init(viewModel: SearchViewModel, coordinator: SearchCoordinator?) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchBar.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
        bind()
    }
    
    private func bind() {
        viewModel.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books = books
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchQuery.onNext(query)
        searchBar.resignFirstResponder()
    }
}
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
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.item]
        coordinator?.showBookDetail(book: selectedBook)
    }
}
