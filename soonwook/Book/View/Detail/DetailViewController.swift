//
//  DetailViewController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissDatailView))
    }
    
    @objc func dismissDatailView() {
        dismiss(animated: true)
    }
}
