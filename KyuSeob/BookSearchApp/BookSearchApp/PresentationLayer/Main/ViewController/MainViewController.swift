//
//  MainViewController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit

class MainViewController: UIViewController {

    private let mainView = MainView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
