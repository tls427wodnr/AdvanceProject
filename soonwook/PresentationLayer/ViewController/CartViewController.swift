//
//  CartViewController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit
internal import RxSwift
internal import RxCocoa

class CartViewController: UIViewController {
    private let cartView = CartView()
    private let viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = cartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        cartView.tableView.dataSource = self
        cartView.tableView.delegate = self
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // viewModel.action?(.onAppear)
        viewModel.input.accept(.onAppear)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "장바구니"
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
    
//    private func bindViewModel() {
//        viewModel.bindCartItem { [weak self] item in
//            DispatchQueue.main.async {
//                self?.cartView.tableView.reloadData()
//            }
//        }
//    }
    
    private let disposeBag = DisposeBag()
    
    private func bindViewModel() {
        viewModel.output.items
            .subscribe { [weak self] items in
                DispatchQueue.main.async {
                    self?.cartView.tableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.input.accept(.removeAll)
            }
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe { [weak self] _ in
                guard let self else { return }
                
                if let tabBarController {
                    tabBarController.selectedIndex = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
                           let searchViewController = navigationController.topViewController as? SearchViewController {
                            searchViewController.searchView.searchBar.becomeFirstResponder()
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
//    @objc func deleteAll() {
//        // viewModel.action?(.removeAll)
//        viewModel.input.accept(.removeAll)
//    }
//    
//    // + 버튼 누르면 search view로 이동하고, search bar 포커싱
//    @objc func add() {
//        if let tabBarController {
//            tabBarController.selectedIndex = 0
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                if let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
//                   let searchViewController = navigationController.topViewController as? SearchViewController {
//                    searchViewController.searchView.searchBar.becomeFirstResponder()
//                }
//            }
//        }
//    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // viewModel.state.items.count
        viewModel.output.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseIdentifier, for: indexPath) as! CartCell
        // cell.update(with: viewModel.state.items[indexPath.row])
        cell.update(with: viewModel.output.items.value[indexPath.row])
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self else { return }
            // let item = viewModel.state.items[indexPath.row]
            let item = viewModel.output.items.value[indexPath.row]
            // viewModel.action?(.removeFromCart(item))
            viewModel.input.accept(.removeFromCart(item))
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
