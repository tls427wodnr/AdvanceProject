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

final class BookDetailViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    private let book: Book
    
    private let bookDetailView = BookDetailView()
    
    private let viewModel: BookDetailViewModel
    
    private let disposeBag = DisposeBag()
    
    var onDismiss: (() -> Void)?
    private var didSaveBook = false
    
    private let viewDidLoadTrigger = PublishRelay<Void>()
    private let saveButtonTappedTrigger = PublishRelay<Void>()
    
    init(book: Book, viewModel: BookDetailViewModel) {
        self.book = book
        self.viewModel = viewModel
        
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
        self.presentationController?.delegate = self
        
        let input = BookDetailViewModel.Input(
            viewDidLoad: viewDidLoadTrigger.asObservable(),
            saveButtonTapped: saveButtonTappedTrigger.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        bindOutput(output)
        bindButtons()
        
        viewDidLoadTrigger.accept(())
    }
    
    private func setupViews() {
        [bookDetailView].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        bookDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindOutput(_ output: BookDetailViewModel.Output) {
        output.dismissWithSaveFlag
            .emit(onNext: { [weak self] isSaved in
                self?.didSaveBook = isSaved
                self?.dismiss(animated: true, completion: {
                    self?.onDismiss?()
                })
            })
            .disposed(by: disposeBag)
        
        output.showError
            .emit(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindButtons() {
        bookDetailView.saveButton.rx.tap
            .bind(to: saveButtonTappedTrigger)
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
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss?()
    }
}
