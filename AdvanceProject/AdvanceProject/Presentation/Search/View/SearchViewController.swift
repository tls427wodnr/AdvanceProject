//
//  SearchViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchView = SearchView()
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
