//
//  OrderCell.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import UIKit

final class OrderCell: UICollectionViewCell, SelfConfiguringOrderCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "OrderCell"

    // MARK: Private properties
    private lazy var orderIdLabel = UILabel()
    private lazy var orderPriceLabel = UILabel()
    private lazy var orderTimeLabel = UILabel()
    private lazy var orderTypeLabel = UILabel()
    private var orderId: String?

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
        let stackView = UIStackView(arrangedSubviews: [
            orderTypeLabel,
            orderIdLabel,
            orderPriceLabel,
            orderTimeLabel
        ])
        contentView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupDisplay() {

    }

    // MARK: Internal methods

    func configure(with cell: OrderEntity) {
        self.orderIdLabel.text = cell.orderId
        self.orderTypeLabel.text = cell.orderType
        self.orderTimeLabel.text = cell.orderTime
        self.orderPriceLabel.text = cell.orderPrice
        self.orderId = cell.orderId
    }
}
