//
//  SectionHeader.swift
//  FoodZ
//
//  Created by surexnx on 30.03.2024.
//

import UIKit
import SnapKit

final class SectionHeaderCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier = "SectionHeader"

    // MARK: Private properties

    private lazy var titleLabel: UILabel = {
        UILabel()
    }()

    private lazy var seeAllButton: UIButton = {
        let action = UIAction { [weak self] _ in

        }
        var button = UIButton(primaryAction: action)
        button.tintColor = .black
        button.setTitle("Посмотреть все", for: .normal)
        return button
    }()

    // MARK: Initializaion

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setpDisplay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal methods

    func configure(title: String) {
        titleLabel.text = title
    }

    // MARK: Private methods

    private func setpDisplay() {
        backgroundColor = AppColor.background.color
        seeAllButton.tintColor = AppColor.primary.color
    }
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, seeAllButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
}
