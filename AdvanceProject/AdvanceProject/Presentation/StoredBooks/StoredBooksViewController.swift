//
//  StoredBooksViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

class StoredBooksViewController: UIViewController {
    
    let storedBooksView = StoredBooksView()
    
    override func loadView() {
        self.view = storedBooksView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
