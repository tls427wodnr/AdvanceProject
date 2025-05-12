//
//  SavedBooksViewController.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit
import RxSwift

class SavedBooksViewController: UIViewController {
    private let savedBooksHeader = SavedBooksHeaderView()
    private var books = [Book]()
    private let disposeBag = DisposeBag()
    private let viewModel = SavedBooksViewModel()
    
    private lazy var savedBooksCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(
            SearchResultCell.self,
            forCellWithReuseIdentifier: SearchResultCell.id
        )
        cv.dataSource = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        bindViewModel()
        viewModel.fetchSavedBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchSavedBooks()
    }
    
    private func setupViews() {
        [
            savedBooksHeader,
            savedBooksCollectionView
        ].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        savedBooksHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        savedBooksCollectionView.snp.makeConstraints {
            $0.top.equalTo(savedBooksHeader.snp.bottom)
            $0.directionalHorizontalEdges.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func bindViewModel() {
        viewModel.savedBooksSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.books = books
                self?.savedBooksCollectionView.reloadData()
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

}

extension SavedBooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultCell.id,
            for: indexPath
        ) as? SearchResultCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: books[indexPath.row])
        
        return cell
    }
}
