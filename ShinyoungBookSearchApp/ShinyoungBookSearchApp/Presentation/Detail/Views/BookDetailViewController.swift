//
//  BookDetailViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BookDetailViewController: UIViewController {
    private let book: Book
    
    private let bookDetailView = BookDetailView()
    
    private let viewModel = BookDetailViewModel()
    
    private let disposeBag = DisposeBag()
    
    var onDismiss: (() -> Void)?
    private var didSaveBook = false
    
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
        bindViewModel()
        viewModel.saveRecentBook(with: book)
    }
    
    private func setupViews() {
        [bookDetailView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        bookDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.favoriteBookSaved
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.onDismiss?()
                })
            }).disposed(by: disposeBag)
        
        viewModel.favoriteBookSaveFailed
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(
                    title: "실패",
                    message: "책 저장에 실패했습니다.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
        bookDetailView.saveButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let book = self?.book else { return }
                
                self?.didSaveBook = true
                self?.viewModel.saveFavoriteBook(with: book)
            })
            .disposed(by: disposeBag)
        
        bookDetailView.dismissButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.onDismiss?()
                })
            })
            .disposed(by: disposeBag)
    }
    
    func wasBookSaved() -> Bool {
        return didSaveBook
    }
}
