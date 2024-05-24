//
//  CartBodyCell.swift
//  FoodZ
//
//  Created by surexnx on 23.05.2024.
//

import UIKit
import SnapKit

final class CartPayBodyCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "CartPayBodyCell"

    // MARK: Private properties

    private lazy var quantityLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var priceLabel = UILabel()

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

        let textStackView: UIStackView = UIStackView(arrangedSubviews: [nameLabel, quantityLabel, priceLabel])
        textStackView.axis = .horizontal
        textStackView.alignment = .center
        textStackView.distribution = .fillEqually
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textStackView)

        textStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupDisplay() {
        contentView.backgroundColor = AppColor.background.color
        setupQuantityLabel()
        setupNameLabel()
        setupPriceLabel()
    }

    private func setupPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 17)
    }

    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupQuantityLabel() {
        quantityLabel.backgroundColor = AppColor.cartBackground.color
        quantityLabel.layer.cornerRadius = 5
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Internal methods

    func configure(with cell: CartPayBody) {
        priceLabel.text = cell.price
        nameLabel.text = cell.name
        quantityLabel.text = cell.quantity
    }
}
