//
//  BookSearchView.swift
//  ShinyoungBookSearchApp
//
//  Created by shinyoungkim on 5/9/25.
//

import UIKit
import SnapKit

final class BookSearchView: UIView {
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchTextField.backgroundColor = .systemGray6
        sb.placeholder = "책 제목을 검색하세요"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var searchBarTrailingToCancelButton: Constraint?
    private var searchBarTrailingToSuperview: Constraint?
    
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
            searchBar,
            cancelButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            
            self.searchBarTrailingToCancelButton = $0.trailing.equalTo(cancelButton.snp.leading).constraint
            self.searchBarTrailingToSuperview = $0.trailing.equalToSuperview().constraint

            self.searchBarTrailingToCancelButton?.deactivate()
        }
        
        cancelButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(searchBar)
        }
    }
    
    func setCancelButtonVisible(_ visible: Bool) {
        if visible {
            cancelButton.isHidden = false
            cancelButton.transform = CGAffineTransform(translationX: 20, y: 0)
            
            searchBarTrailingToSuperview?.deactivate()
            searchBarTrailingToCancelButton?.activate()
            
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut]) {
                self.layoutIfNeeded()
                self.cancelButton.transform = .identity
            }
        } else {
            searchBarTrailingToCancelButton?.deactivate()
            searchBarTrailingToSuperview?.activate()
            
            UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseIn], animations: {
                self.layoutIfNeeded()
                self.cancelButton.transform = CGAffineTransform(translationX: 20, y: 0)
            }) { _ in
                self.cancelButton.isHidden = true
                self.cancelButton.transform = .identity
            }
        }
    }
}
