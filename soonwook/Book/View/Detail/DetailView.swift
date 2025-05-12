//
//  DetailView.swift
//  Book
//
//  Created by 권순욱 on 5/12/25.
//

import UIKit
import SnapKit

protocol DetailViewDelegate: AnyObject {
    func cancelButtonTapped()
    func addButtonTapped()
}

class DetailView: UIView {
    let scrollView = UIScrollView()
    
    // 하단 버튼 뷰(플로팅 뷰)
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        return stackView
    }()
    
    // 스크롤 내부 뷰(bookStackView를 래핑)
    let contentView = UIView()
    
    // 책 정보 뷰
    let bookStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }()
    
    // 책 제목
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // 저자
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // 책 이미지
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    // 가격
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .right
        return label
    }()
    
    // 책 소개
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    // 취소하고 화면 닫기
    let cancelButton: UIButton = {
        var configuration = UIButton.Configuration.gray()
        configuration.title = "닫기"
        configuration.buttonSize = .large
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    // 장바구니 담기
    let addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "장바구니 담기"
        configuration.buttonSize = .large
        configuration.cornerStyle = .capsule
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    weak var delegate: DetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        prepareSubviews()
        
        setConstraints()
        
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareSubviews() {
        [scrollView, buttonStackView].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(bookStackView)
        
        [titleLabel, authorLabel, imageView, priceLabel, contentLabel].forEach {
            bookStackView.addArrangedSubview($0)
        }
        
        [cancelButton, addButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(buttonStackView.snp.top)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        bookStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(300)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(addButton.snp.width).multipliedBy(0.3)
        }
    }
    
    private func setAction() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }
    
    @objc private func addButtonTapped() {
        delegate?.addButtonTapped()
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.authors.joined(separator: ", ")
        priceLabel.text = book.price.wonFormatter()
        contentLabel.text = book.contents
        
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: book.thumbnail),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.sync {
                    self?.imageView.image = image
                }
            }
        }
    }
}
