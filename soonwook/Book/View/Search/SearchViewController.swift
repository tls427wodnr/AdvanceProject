//
//  SearchViewController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchView = SearchView()
    private let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "검색"
        
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        
        searchView.searchBar.delegate = self
        
        bindViewModel()
    }
    
    func bindViewModel() {
        // book 데이터가 바뀌면 컬렉션 뷰 리로드
        viewModel.bindBook { [weak self] books in
            DispatchQueue.main.async {
                self?.searchView.collectionView.reloadData()
            }
        }
        
        viewModel.bindError { [weak self] error in
            if let error {
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.state.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .recentlyViewed:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecentlyViewedCell.reuseIdentifier,
                for: indexPath
            ) as! RecentlyViewedCell
            return cell
        case .searchResult:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchResultCell.reuseIdentifier,
                for: indexPath
            ) as! SearchResultCell
            cell.update(with: viewModel.state.books[indexPath.item])
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SearchHeader.reuseIdentifier,
            for: indexPath
        ) as! SearchHeader
        
        let section = Section(rawValue: indexPath.section)!
        headerView.configure(with: section.title)
        
        return headerView
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = DetailViewModel(book: viewModel.state.books[indexPath.item], cartRepository: viewModel.cartRepository)
        let viewController = DetailViewController(viewModel: viewModel)
        present(viewController, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.searchBook(searchText))
    }
}
