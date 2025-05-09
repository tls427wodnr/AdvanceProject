//
//  BookSearchViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

final class BookSearchViewController: UIViewController, UISearchBarDelegate {
    private let bookSearchView = BookSearchView()

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
            bookSearchView
        ].forEach { view.addSubview($0) }
        
        bookSearchView.setCancelButtonVisible(false)
    }
    
    private func setupConstraints() {
        bookSearchView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view).inset(16)
        }
    }
    
    private func setupSearchBar() {
        bookSearchView.searchBar.delegate = self
    }
    
    private func setupActions() {
        bookSearchView.cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func cancelButtonDidTap() {
        bookSearchView.searchBar.text = ""
        bookSearchView.searchBar.resignFirstResponder()
        bookSearchView.setCancelButtonVisible(false)
    }
}

extension BookSearchViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        bookSearchView.setCancelButtonVisible(true)
    }
}
