//
//  StoredBooksViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit
import RxSwift
import RxRelay

final class StoredBooksViewController: UIViewController {

    // MARK: - UI & Properties
    private let storedBooksView = StoredBooksView()
    private let viewModel: StoredBooksViewModel
    private weak var coordinator: StoredBooksCoordinator?
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(viewModel: StoredBooksViewModel, coordinator: StoredBooksCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "담은 책", image: UIImage(systemName: "bookmark.fill"), tag: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func loadView() {
        view = storedBooksView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchStoredBooks()
    }

    // MARK: - Setup
    private func setupTableView() {
        let tableView = storedBooksView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookTableCell.self, forCellReuseIdentifier: BookTableCell.identifier)
    }

    private func setupNavigation() {
        title = "담은 책"
        view.backgroundColor = .systemBackground

        let clearButton = UIBarButtonItem(
            title: "전체 삭제",
            style: .plain,
            target: self,
            action: #selector(didTapClearAll)
        )
        clearButton.tintColor = .systemRed
        navigationItem.leftBarButtonItem = clearButton

        let addButton = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(didTapAdd)
        )
        addButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = addButton
    }

    private func bind() {
        viewModel.books
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.storedBooksView.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.removedBook
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] book in
                self?.view.showToast(message: "『\(book.title)』을 삭제했어요")
            })
            .disposed(by: disposeBag)
    }


    // MARK: - Actions
    @objc private func didTapClearAll() {
        viewModel.clearAll()
    }

    @objc private func didTapAdd() {
        guard let tabBarController = self.tabBarController,
              let searchNav = tabBarController.viewControllers?.first as? UINavigationController,
              let searchVC = searchNav.viewControllers.first as? SearchViewController else {
            return
        }

        tabBarController.selectedIndex = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            searchVC.focusSearchBar()
        }
    }
    
    deinit {
        print("deinitialized")
    }
}

// MARK: - UITableViewDataSource
extension StoredBooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.books.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BookTableCell.identifier,
            for: indexPath
        ) as? BookTableCell,
        let book = viewModel.book(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configure(with: book)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StoredBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self = self,
                  let book = self.viewModel.book(at: indexPath.row) else {
                completion(false)
                return
            }

            self.viewModel.remove(book: book)

            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [delete])
    }
}


