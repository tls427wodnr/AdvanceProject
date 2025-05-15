//
//  BookDetailViewController.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/12/25.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - BookDetailBottomSheetViewController

class BookDetailBottomSheetViewController: UIViewController {
    
    // MARK: - Properties

    private var viewModel: BookDetailBottomSheetViewModelProtocol
    private let addTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let buttonContainerView = UIView()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("담기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 22
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    init(viewModel: BookDetailBottomSheetViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupButtonActions()
        bindViewModel()
    }

    // MARK: - Configuration

    func configure(with item: BookItem) {
        titleLabel.text = item.title
        authorLabel.text = item.author
        publisherLabel.text = item.publisher
        descriptionLabel.text = item.description

        if let url = URL(string: item.image) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }.resume()
        }
    }

    // MARK: - Bindings

    private func bindViewModel() {
        let input = BookDetailBottomSheetViewModelInput(addTrigger: addTrigger.asObservable())
        let output = viewModel.transform(input: input)

        output.added
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        output.error
            .drive(onNext: { [weak self] message in
                let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Layout

    private func setupLayout() {
        setupScrollView()
        setupButtonArea()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(buttonContainerView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonContainerView.topAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
        ])

        [titleLabel, authorLabel, imageView, publisherLabel, descriptionLabel].forEach {
            contentStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        }
    }

    private func setupButtonArea() {
        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView(arrangedSubviews: [closeButton, actionButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fill
        buttonStack.alignment = .fill
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonContainerView.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),

            buttonStack.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Actions

    private func setupButtonActions() {
        closeButton.addTarget(self, action: #selector(handleCloseTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(handleAddTapped), for: .touchUpInside)
    }

    @objc private func handleCloseTapped() {
        dismiss(animated: true)
    }

    @objc private func handleAddTapped() {
        addTrigger.accept(())
    }
}
