//
//  DetailViewController.swift
//  Book
//
//  Created by 권순욱 on 5/8/25.
//

import UIKit

class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        viewModel.action?(.onAppear)
        
        detailView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.bindBook { [weak self] book in
            guard let self, let book else { return }
            detailView.configure(with: book)
        }
    }
}

extension DetailViewController: DetailViewDelegate {
    func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    func addButtonTapped() {
        viewModel.action?(.addToCart)
        showAlert(title: "장바구니 담기 완료", message: "선택한 상품이 장바구니에 추가되었습니다.")
    }
}
