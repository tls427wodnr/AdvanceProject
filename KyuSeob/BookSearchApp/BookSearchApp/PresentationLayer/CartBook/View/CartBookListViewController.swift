//
//  MyBooksViewController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class CartBookListViewController: UIViewController {
    private let viewModel: CartBookListViewModel
    private let disposeBag = DisposeBag()

    private let leftButton = UIBarButtonItem(
        title: "전체 삭제",
        style: .plain,
        target: nil,
        action: nil
    )

    private let rightButton = UIBarButtonItem(
        title: "추가",
        style: .plain,
        target: nil,
        action: nil
    )

    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(
            CartBookTableViewCell.self,
            forCellReuseIdentifier: CartBookTableViewCell.identifier
        )
        $0.separatorStyle = .none
    }

    private lazy var emptyView = EmptyView().then {
        $0.configure(with: "아직 담은 책이 없어요")
    }

    init(viewModel: CartBookListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchCartBooks()
    }

}

private extension CartBookListViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()
    }

    func setStyle() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "담은 책"

        let font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        leftButton.tintColor = .systemRed
        leftButton.setTitleTextAttributes([.font: font], for: .normal)
        self.navigationItem.leftBarButtonItem = leftButton

        rightButton.tintColor = .init(hex: "63c466")
        rightButton.setTitleTextAttributes([.font: font], for: .normal)
        self.navigationItem.rightBarButtonItem = rightButton

        self.tableView.clipsToBounds = false
        self.tableView.backgroundColor = .clear
    }

    func setHierarchy() {
        view.addSubviews(views: tableView, emptyView)
    }

    func setConstraints() {
        tableView.snp.makeConstraints {
            $0.directionalVerticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        emptyView.snp.makeConstraints {
            $0.edges.equalTo(tableView)
        }
    }

    func bind() {
        viewModel.cartBooks
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.tableView.reloadData()
            }).disposed(by: disposeBag)

        rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.focusSearchInTab()
            })
            .disposed(by: disposeBag)

        leftButton.rx.tap
            .subscribe(onNext: {
                self.showConfirmationAlert(title: "다시 확인해주세요", message: "담은 책들을 초기화하시겠습니까?") { [weak self] in
                    guard let self else { return }
                    viewModel.deleteAllTapped.accept(())
                }
            })
            .disposed(by: disposeBag)

        viewModel.didSuccessEvent
            .subscribe(onNext: { [weak self] event in
                guard let self else { return }
                switch event {
                case .deleteAll:
                    self.showNoticeAlert(message: "담은 책을 모두 삭제했습니다.", title: "전체 삭제 완료") { [weak self] in
                        guard let self else { return }
                        viewModel.fetchCartBooks()
                    }
                case .deleteOne:
                    viewModel.fetchCartBooks()
                }

            }).disposed(by: disposeBag)
    }

    func focusSearchInTab() {
        if let tabBarController = self.tabBarController,
           let viewControllers = tabBarController.viewControllers,
           let nav = viewControllers[0] as? UINavigationController,
           let mainVC = nav.viewControllers.first as? MainViewController {
            tabBarController.selectedIndex = 0
            DispatchQueue.main.async {
                mainVC.activateSearchBar()
            }
        }
    }
}

extension CartBookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.cartBooks.value.count
        emptyView.isHidden = count != 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartBookTableViewCell.identifier
        ) as? CartBookTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.cartBooks.value[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

extension CartBookListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            guard let self else { return }
            let book = self.viewModel.cartBooks.value[indexPath.row]
            self.showConfirmationAlert(title: "삭제 확인", message: "이 책을 삭제할까요?") {
                self.viewModel.deleteOneTapped.accept(book)
            }
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
