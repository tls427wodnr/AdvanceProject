//
//  MainViewController.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxSwift
import SnapKit
import Then

class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()

    private var searchResultBooks = [Book]()

    private let searchBar = UISearchBar().then {
        $0.placeholder = "책 제목을 입력해주세요"
        $0.searchBarStyle = .minimal
        $0.backgroundColor = .systemBackground
    }

    private lazy var resultCollectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            SearchResultTableViewCell.self,
            forCellWithReuseIdentifier: SearchResultTableViewCell.identifier
        )
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier
        )

        return collectionView
    }()

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension MainViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()
    }

    func setStyle() {
        view.backgroundColor = .systemBackground // TODO: - 트러블슈팅 기록용
        navigationController?.navigationBar.isHidden = true
    }

    func setHierarchy() {
        view.addSubviews(views: searchBar, resultCollectionView)
    }

    func setConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(44)
        }

        resultCollectionView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
    }

    func bind() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .bind(onNext: { [weak self] query in
                self?.viewModel.searchBooks(with: query)
                self?.resultCollectionView.reloadData()
            }).disposed(by: disposeBag)

        searchBar.rx.text.orEmpty
            .bind(onNext: { [weak self] text in
                if text.isEmpty {
                    self?.searchResultBooks = []
                    self?.resultCollectionView.reloadData()
                }
            }).disposed(by: disposeBag)

        viewModel.searchResultBooks
            .subscribe(onNext: { [weak self] books in
                self?.searchResultBooks = books
                self?.resultCollectionView.reloadData()
            }).disposed(by: disposeBag)
    }

    func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 10, leading: 20, bottom: 20, trailing: 20)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchResultTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultTableViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(book: searchResultBooks[indexPath.item])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        header.configure(with: "검색 결과")

        return header
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = BookDetailViewController()
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
