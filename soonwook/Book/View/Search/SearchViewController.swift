//
//  SearchViewController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class SearchViewController: UIViewController {
    let searchView = SearchView()
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
        
        setDelegate()
        
        bindViewModel()
        
        viewModel.action?(.onAppear)
    }
    
    private func setDelegate() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self
        
        searchView.searchBar.delegate = self
    }
    
    private func bindViewModel() {
        // book 데이터가 바뀌면 컬렉션 뷰 리로드
        viewModel.bindBook { [weak self] books in
            DispatchQueue.main.async {
                self?.searchView.collectionView.reloadData()
            }
        }
        
        // history 데이터가 바뀌면 컬렉션 뷰 리로드
        viewModel.bindHistory { [weak self] histories in
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
        let section = Section(rawValue: section)
        switch section {
        case .history:
            return viewModel.state.histories.count
        case .searchResult:
            return viewModel.state.books.count
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .history:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HistoryCell.reuseIdentifier,
                for: indexPath
            ) as! HistoryCell
            cell.update(with: viewModel.state.histories[indexPath.item])
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
        let section = Section(rawValue: indexPath.section)
        
        switch section {
        case .history:
            let history = viewModel.state.histories[indexPath.item]
            let book = Book(isbn: history.isbn, title: history.title, authors: history.authors, price: history.price, contents: history.contents, thumbnail: history.thumbnail)
            let viewController = makeDetailViewController(book: book)
            present(viewController, animated: true)
        case .searchResult:
            let book = viewModel.state.books[indexPath.item]
            let viewController = makeDetailViewController(book: book)
            present(viewController, animated: true)
        case .none:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if !viewModel.state.books.isEmpty, offsetY > contentHeight - height - 100 {
            viewModel.action?(.onScrollEnd)
        }
    }
    
    private func makeDetailViewController(book: Book) -> DetailViewController {
        let viewModel = DetailViewModel(book: book, cartRepository: viewModel.cartRepository, historyRepository: viewModel.historyRepository)
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.onDismiss = { [weak self] in
            self?.viewModel.action?(.onAppear)
        }
        
        return viewController
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.searchBook(searchText))
    }
}
