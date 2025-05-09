//
//  BookDetailViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

final class BookDetailViewController: UIViewController {
    private let book: Book
    
    private let bookDetailView = BookDetailView()
    
    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        bookDetailView.configure(with: book)
        setupActions()
    }
    
    private func setupViews() {
        [bookDetailView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        bookDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        bookDetailView.dismissButton.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        bookDetailView.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func dismissButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        print("saveButton")
    }
}
