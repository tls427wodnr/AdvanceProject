//
//  SearchResultTableViewCell.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxSwift

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultCollectionViewCell"
    private let disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }

    private let authorLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 40
    }

    private let priceLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }

    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.layer.shadowColor = UIColor(hex: "1A1A1A")?.cgColor
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(book: Book) {
        titleLabel.text = book.title
        authorLabel.text = {
            let authors = book.authors
            switch authors.count {
            case 0: return "저자 미상"
            case 1: return authors.first ?? ""
            default:
                return "\(authors.first ?? "") 외 \(authors.count - 1)명"
            }
        }()
        priceLabel.text = String(book.price) + "원"
        ImageLoader.shared.load(from: book.thumbnail)
            .subscribe(onSuccess: { value in
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = value != nil ? value : .init(systemName: "xmark")?.withTintColor(.black)
                }
            }, onFailure: { error in
                print(error)
            }).disposed(by: disposeBag)
    }
}

private extension SearchResultCollectionViewCell {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()
    }

    func setStyle() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white // 배경색 추가

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false

        contentView.clipsToBounds = false
    }

    func setHierarchy() {
        contentView.addSubviews(views: thumbnailImageView, horizontalStackView)
        verticalStackView.addArrangedSubviews(views: titleLabel, authorLabel)
        horizontalStackView.addArrangedSubviews(views: verticalStackView, priceLabel)
    }

    func setConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }

        horizontalStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }

    func bind() {

    }
}
