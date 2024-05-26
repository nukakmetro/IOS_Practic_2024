//
//  CartMainInfoView.swift
//  FoodZ
//
//  Created by surexnx on 24.05.2024.
//

import UIKit

final class CartMainInfoView: UIView {

    // MARK: Internal properties

    var tappedPayBuuton: (() -> Void)?

    // MARK: Private properties

    private lazy var totalPriceLabel = UILabel()
    private lazy var payButton = UIButton()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDisplay()
        makeContraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeContraint() {
        let stackView = UIStackView(arrangedSubviews: [totalPriceLabel, payButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = AppColor.background.color
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }

    }
    private func setupDisplay() {
        let action = UIAction { [weak self] _ in
            guard let self = self,
                  let tappedPayButton = tappedPayBuuton
            else { return }
            tappedPayButton()
        }
        payButton.addAction(action, for: .touchUpInside)
        totalPriceLabel.text = "Сумма: "
        backgroundColor = AppColor.background.color
        payButton.setTitle("Корзина пустая", for: .normal)
        payButton.layer.cornerRadius = 10

    }

    // MARK: Internal methods

    func configure(viewData: CartViewData) {

        totalPriceLabel.text = "Сумма: " + String(viewData.totalPrice)

        payButton.isEnabled = true

        if viewData.totalPrice == 0 {
            payButton.isEnabled = false
            payButton.setTitle("Корзина пустая", for: .normal)
            payButton.backgroundColor = .red
        } else {
            payButton.backgroundColor = .blue
            payButton.setTitle("Перейти к оформлению", for: .normal)
        }
    }
}
