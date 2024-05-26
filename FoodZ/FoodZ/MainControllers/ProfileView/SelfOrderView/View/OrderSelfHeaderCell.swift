//
//  SelfOrderInfoCell.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import UIKit
import SnapKit

final class OrderSelfHeaderCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "SelfOrderHeaderCell"

    // MARK: Private properties

    private lazy var orderIdLabel = UILabel()
    private lazy var totalPriceLabel = UILabel()
    private lazy var statusLabel = UILabel()
    private lazy var whoseLabel = UILabel()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDisplay()
        makeConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraint() {

        let stackView = UIStackView(arrangedSubviews: [orderIdLabel, totalPriceLabel, whoseLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20

        contentView.addSubview(statusLabel)
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(20)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView).inset(20)
            make.leading.equalToSuperview().inset(20)
        }
    }

    private func setupDisplay() {
        contentView.backgroundColor = AppColor.background.color
    }

    // MARK: Internal methods

    func configure(with cell: OrderSelfHeader) {

        totalPriceLabel.text = cell.totalPrice
        orderIdLabel.text = cell.orderId

        switch cell.status {
        case 0:
            statusLabel.text = "Не готов"
        case 1:
            statusLabel.text = "Готов"
        case 2:
            statusLabel.text = "Завершен"
        default:
            break
        }

        switch cell.whose {
        case true:
            whoseLabel.text = "Мне"
        case false:
            whoseLabel.text = "От меня"
        }
    }
}
