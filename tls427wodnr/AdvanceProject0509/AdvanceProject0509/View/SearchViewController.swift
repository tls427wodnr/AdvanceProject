//
//  SearchViewController.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {

    // MARK: - UI

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "책 제목을 검색하세요"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.identifier)
        return collectionView
    }()

    // MARK: - Properties

    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        title = "도서 검색"
        view.backgroundColor = .systemBackground

        view.addSubview(searchBar)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Bindings

    private func bindViewModel() {
        
        let input = SearchViewModel.Input(
            query: searchBar.rx.text.orEmpty
                .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
        )

        let output = viewModel.transform(input: input)

        output.books
            .drive(collectionView.rx.items(
                cellIdentifier: BookCell.identifier,
                cellType: BookCell.self
            )) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)

        output.error
            .emit(onNext: { [weak self] error in
                let alert = UIAlertController(
                    title: "에러",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(BookItem.self)
            .subscribe(onNext: { book in
                let bottomSheetVC = BookDetailBottomSheetViewController()
                bottomSheetVC.configure(with: book)
                bottomSheetVC.modalPresentationStyle = .pageSheet

                if let sheet = bottomSheetVC.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.selectedDetentIdentifier = .large
                    sheet.prefersGrabberVisible = true
                }

                self.present(bottomSheetVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Layout

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }
}
