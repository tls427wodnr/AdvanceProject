//
//  RecentBooksView.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/14/25.
//
import UIKit
import SnapKit
import Then

final class RecentBooksView: UIView {

    // MARK: - UI
    private let titleLabel = UILabel().then {
        $0.text = "최근 본 책"
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let deleteButton = UIButton(type: .system).then {
        $0.setTitle("전체 삭제", for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }

    private let headerStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Event
    var onTapDelete: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupLayout() {
        addSubview(headerStack)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(deleteButton)

        addSubview(collectionView)

        headerStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerStack.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
    }

    @objc private func deleteButtonTapped() {
        onTapDelete?()
    }
}
