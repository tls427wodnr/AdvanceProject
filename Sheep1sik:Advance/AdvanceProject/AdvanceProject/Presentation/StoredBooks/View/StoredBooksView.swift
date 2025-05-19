//
//  StoredBooksView.swift
//  AdvanceProject
//
//  Created by 양원식 on 5/9/25.
//

import UIKit
import SnapKit
import Then

final class StoredBooksView: UIView {

    // MARK: - UI Components
    let tableView = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.rowHeight = 120
        $0.backgroundColor = .systemBackground
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    private func setupLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
