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
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()

    private let dummyButton = UIButton().then {
        $0.setTitle("디테일 뷰", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
}

private extension MainViewController {

}

private extension MainViewController {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        bind()
    }

    func setStyle() {

    }

    func setHierarchy() {
        view.addSubViews(views: dummyButton)
    }

    func setConstraints() {
        dummyButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
    }

    func bind() {
        dummyButton.rx.tap
            .bind(to: viewModel.dummyButtonTapped)
            .disposed(by: disposeBag)

        viewModel.showDetailView
            .subscribe(onNext: { [weak self] in
                let detailViewController = BookDetailViewController()
                self?.navigationController?.pushViewController(detailViewController, animated: true)
            }).disposed(by: disposeBag)
    }
}
