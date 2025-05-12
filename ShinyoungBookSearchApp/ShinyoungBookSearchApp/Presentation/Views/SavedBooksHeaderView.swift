//
//  SavedBooksHeaderView.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/12/25.
//

import UIKit
import SnapKit

final class SavedBooksHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "담은 책"
        return label
    }()
    
    let allDeleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "trash")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            titleLabel,
            allDeleteButton,
            addButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        allDeleteButton.snp.makeConstraints {
            $0.trailing.equalTo(addButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
