//
//  CartFooter.swift
//  FoodZ
//
//  Created by surexnx on 23.05.2024.
//

import UIKit
import SnapKit

final class CartPayFooterCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "CartPayFooterCell"

    // MARK: Internal properties

    var proccesedTappedButtonPay: (() -> Void)?

    // MARK: Private properties

    private lazy var totalPriceLabel = UILabel()
    private lazy var payButton = UIButton()

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
        let stackView = UIStackView(arrangedSubviews: [totalPriceLabel, payButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = AppColor.background.color

        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    private func setupDisplay() {
        contentView.backgroundColor = AppColor.background.color
        setupTotalPriceLabel()
        setupPayButton()
    }

    private func setupTotalPriceLabel() {
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.font = .systemFont(ofSize: 15)
    }

    private func setupPayButton() {
        let action = UIAction { [weak self] _ in
            guard
                let self = self,
                let proccesedTappedButtonPay = proccesedTappedButtonPay
            else { return }
            proccesedTappedButtonPay()
        }
        payButton.addAction(action, for: .touchUpInside)
        payButton.setTitle("Оплатить", for: .normal)
        payButton.layer.cornerRadius = 5
        payButton.backgroundColor = .blue
        payButton.translatesAutoresizingMaskIntoConstraints = false
    }


    // MARK: Internal methods

    func configure(with cell: CartPayFooter) {
        totalPriceLabel.text = cell.totalPrice
    }
}
