//
//  SavedBooksViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit
import RxSwift

class SavedBooksViewController: UIViewController {
    private let savedBooksHeader = SavedBooksHeaderView()
    private var books = [Book]()
    private let disposeBag = DisposeBag()
    private let viewModel = SavedBooksViewModel()
    
    private lazy var savedBooksTableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(SavedBookListCell.self, forCellReuseIdentifier: SavedBookListCell.id)
        tv.separatorStyle = .none
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchSavedBooks()
    }
    
    private func setupViews() {
        [
            savedBooksHeader,
            savedBooksTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        savedBooksHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        savedBooksTableView.snp.makeConstraints {
            $0.top.equalTo(savedBooksHeader.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func bindViewModel() {
        viewModel.savedBooksDriver
            .drive(onNext: { [weak self] books in
                self?.books = books
                self?.savedBooksTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        savedBooksHeader.addButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.tabBarController?.selectedIndex = 0
                
                if let searchVC = self?.tabBarController?.viewControllers?.first as? UINavigationController,
                   let bookSearchVC = searchVC.viewControllers.first as? BookSearchViewController {
                    bookSearchVC.focusSearchBar()
                }
            })
            .disposed(by: disposeBag)
        
        savedBooksHeader.deleteAllBooksButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.deleteAllBooks()
            })
            .disposed(by: disposeBag)
    }
}

extension SavedBooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SavedBookListCell.id,
            for: indexPath
        ) as? SavedBookListCell else {
            return UITableViewCell()
        }

        cell.configure(with: books[indexPath.row])
        
        return cell
    }
}

extension SavedBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            let book = self.books[indexPath.row]
            self.viewModel.deleteBook(isbn: book.isbn)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

