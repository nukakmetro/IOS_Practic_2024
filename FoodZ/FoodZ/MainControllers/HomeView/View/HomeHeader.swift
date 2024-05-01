//
//  SearhBarUIview.swift
//  FoodZ
//
//  Created by surexnx on 02.04.2024.
//

import UIKit
import SnapKit

protocol HomeHeaderDelegate: AnyObject {
    func proccesedButtonTapToSearch()
}

class HomeHeader: UICollectionReusableView {

    // MARK: Internal static properties

    static var reuseIdentifier: String = "HomeHeader"

    // MARK: Internal properties

    weak var homeDelegate: HomeHeaderDelegate?

    // MARK: Private properties

    private lazy var titleLabel: UILabel = { return UILabel() }()

    private lazy var subTitleLabel: UILabel = { return UILabel() }()

    private lazy var searchButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.homeDelegate?.proccesedButtonTapToSearch()
        }

        var button = UIButton(primaryAction: action)
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.backgroundColor = AppColor.background.color
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.setTitle("Поиск", for: .normal)
        button.layer.cornerRadius = frame.height * 0.3 / 2

        return button
    }()

    // MARK: Initializator

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConsraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConsraints() {

        titleLabel.text = "Hello"
        subTitleLabel.text = "chtoto"
        backgroundColor = AppColor.primary.color
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        titleStackView.axis = .vertical
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchButton)
        addSubview(titleStackView)

        titleStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().inset(20)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
}
