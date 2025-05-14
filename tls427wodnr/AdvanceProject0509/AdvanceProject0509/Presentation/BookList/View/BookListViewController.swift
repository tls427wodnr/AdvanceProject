//
//  BookListViewController.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import UIKit
import RxSwift
import RxCocoa

class BookListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel: BookListViewModelProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: - Input Relays
    private let loadTrigger = PublishRelay<Void>()
    private let deleteTrigger = PublishRelay<String>()
    private let deleteAllTrigger = PublishRelay<Void>()
    
    init(viewModel: BookListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTrigger.accept(())
    }
    
    private func bindViewModel() {
        let input = BookListViewModelInput(
            loadTrigger: loadTrigger.asObservable(),
            deleteTrigger: deleteTrigger.asObservable(),
            deleteAllTrigger: deleteAllTrigger.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.books
            .drive(tableView.rx.items(
                cellIdentifier: BookListTableViewCell
                    .identifier,
                cellType: BookListTableViewCell
                    .self
            )) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .withLatestFrom(output.books) { indexPath, books in
                return books[indexPath.row].isbn
            }
            .bind(to: deleteTrigger)
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] message in
                let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.register(BookListTableViewCell
            .self, forCellReuseIdentifier: BookListTableViewCell
            .identifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "담은 책"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let deleteAllButton = UIBarButtonItem(
            title: "전체 삭제",
            style: .plain,
            target: self,
            action: #selector(deleteAllTapped)
        )
        deleteAllButton.tintColor = .lightGray
        navigationItem.leftBarButtonItem = deleteAllButton
        
        let addButton = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        addButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - Actions
    
    @objc private func deleteAllTapped() {
        deleteAllTrigger.accept(())
    }
    
    @objc private func addTapped() {
        tabBarController?.selectedIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            SearchFocusEvent.shared.focusTrigger.accept(())
        }
    }
}
