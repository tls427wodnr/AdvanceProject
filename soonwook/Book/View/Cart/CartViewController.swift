//
//  CartViewController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class CartViewController: UIViewController {
    private let cartView = CartView()
    
    override func loadView() {
        view = cartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "장바구니"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        cartView.tableView.dataSource = self
    }
    
    @objc func deleteAll() {}
    
    @objc func add() {}
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.reuseIdentifier, for: indexPath) as! CartCell
        
        return cell
    }
}
