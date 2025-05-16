//
//  RecentBookCollectionViewCell.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import UIKit
import SDWebImage

// MARK: - RecentBookCollectionViewCell

final class RecentBookCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "RecentBookCollectionViewCell"
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Placeholder

    private static let placeholderImage: UIImage? = {
        UIImage(systemName: "book")?.withRenderingMode(.alwaysTemplate)
    }()
    
    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = Self.placeholderImage
    }
    
    // MARK: - Configuration
    
    func configure(with image: String) {
        let placeholder = Self.placeholderImage
        if let url = URL(string: image) {
            imageView.sd_setImage(
                with: url,
                placeholderImage: placeholder,
                options: [.retryFailed, .scaleDownLargeImages],
                completed: nil
            )
        } else {
            imageView.image = placeholder
        }
    }
}
