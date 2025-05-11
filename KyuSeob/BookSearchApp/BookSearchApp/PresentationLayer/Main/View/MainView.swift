//
//  BookDetailView.swift
//  BookSearchApp
//
//  Created by 송규섭 on 5/11/25.
//

import UIKit
import RxCocoa
import SnapKit
import Then

final class MainView: UIView {
    private let dummyButton = UIButton().then {
        $0.setTitle("디테일 뷰", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    var dummyBtnTapped: ControlEvent<Void> {
        return dummyButton.rx.tap
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}

private extension MainView {
    func configure() {
        setStyle()
        setHierarchy()
        setConstraints()
        setAction()
    }

    func setStyle() {

    }

    func setHierarchy() {
        addSubViews(views: dummyButton)
    }

    func setConstraints() {
        dummyButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            $0.center.equalToSuperview()
        }
    }

    func setAction() {
        
    }
}

