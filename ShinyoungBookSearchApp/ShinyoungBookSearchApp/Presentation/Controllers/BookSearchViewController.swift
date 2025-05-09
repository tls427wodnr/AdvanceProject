//
//  BookSearchViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

final class BookSearchViewController: UIViewController, UISearchBarDelegate {
    private let bookSearchBar = BookSearchBar()
    
    private lazy var bookSearchResultCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupSearchBar()
        setupActions()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [
            bookSearchBar
        ].forEach { view.addSubview($0) }
        
        bookSearchBar.setCancelButtonVisible(false)
    }
    
    private func setupConstraints() {
        bookSearchBar.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view).inset(16)
        }
    }
    
    private func setupSearchBar() {
        bookSearchBar.searchBar.delegate = self
    }
    
    private func setupActions() {
        bookSearchBar.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func cancelButtonDidTap() {
        bookSearchBar.searchBar.text = ""
        bookSearchBar.searchBar.resignFirstResponder()
        bookSearchBar.setCancelButtonVisible(false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: <#T##NSCollectionLayoutSection#>)
    }
}

extension BookSearchViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        bookSearchBar.setCancelButtonVisible(true)
    }
}
