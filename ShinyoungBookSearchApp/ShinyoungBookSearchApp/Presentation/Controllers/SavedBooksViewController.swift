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
        setupActions()
        bindViewModel()
        viewModel.fetchSavedBooks()
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
    
    private func setupActions() {
        savedBooksHeader.deleteAllBooksButton.addTarget(
            self,
            action: #selector(deleteAllBooksButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        viewModel.savedBooksSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books = books
                self?.savedBooksTableView.reloadData()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
        
        viewModel.deleteAllBooksSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDeletedAll in
                if isDeletedAll {
                    self?.books = []
                    self?.savedBooksTableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        viewModel.deletebookSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDeleted in
                if isDeleted {
                    self?.savedBooksTableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
    @objc private func deleteAllBooksButtonDidTap() {
        viewModel.deleteAllBooks()
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
            self.viewModel.deleteBook(title: book.title)
            self.books.remove(at: indexPath.row)
            savedBooksTableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
