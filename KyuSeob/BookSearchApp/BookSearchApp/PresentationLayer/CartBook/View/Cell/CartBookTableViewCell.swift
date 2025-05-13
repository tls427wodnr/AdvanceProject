//
//  CartBookTableViewCell.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/13/25.
//

import UIKit
import RxSwift
import SnapKit

class CartBookTableViewCell: UITableViewCell {
    static let identifier = "CartBookTableViewCell"
    private let disposeBag = DisposeBag()

    private let containerView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
    }

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CartBookTableViewCell.identifier)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not been implemented.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    func configure(with cartBook: CartBook) {
        let book = cartBook.book

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

private extension CartBookTableViewCell {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
    }

    func setStyle() {
        selectionStyle = .none

        backgroundColor = .clear // - TODO: 트러블슈팅
        contentView.backgroundColor = .clear

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false

        contentView.clipsToBounds = false
    }

    func setHierarchy() {
        contentView.addSubviews(views: containerView)
        containerView.addSubviews(views: thumbnailImageView, horizontalStackView)
        verticalStackView.addArrangedSubviews(views: titleLabel, authorLabel)
        horizontalStackView.addArrangedSubviews(views: verticalStackView, priceLabel)
    }

    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.directionalVerticalEdges.equalToSuperview().inset(10)
        }

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
}
