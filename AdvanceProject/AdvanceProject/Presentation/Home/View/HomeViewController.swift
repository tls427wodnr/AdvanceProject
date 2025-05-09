//
//  HomeViewController.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    let homeView = HomeView()
    
    
    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

