//
//  SelfOrderItemCell.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import UIKit

final class OrderSelfItemCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "OrderSelfItemCell"

    // MARK: Private properties
    private lazy var productImage = CustomImageView()
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
        let textStackView: UIStackView = UIStackView(arrangedSubviews: [quantityLabel, priceLabel])
        textStackView.axis = .horizontal
        textStackView.alignment = .center
        textStackView.distribution = .fillEqually
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameLabel)
        contentView.addSubview(productImage)
        contentView.addSubview(textStackView)

        productImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(productImage.snp.trailing).offset(20)
        }
        textStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(productImage.snp.trailing).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    private func setupDisplay() {
        contentView.backgroundColor = AppColor.background.color
        setupQuantityLabel()
        setupNameLabel()
        setupPriceLabel()
        setupImage()
    }

    private func setupImage() {
        productImage.tintColor = AppColor.title.color
        productImage.contentMode = .scaleAspectFill
        productImage.clipsToBounds = true
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

    func configure(with cell: OrderSelfBody) {
        priceLabel.text = cell.price
        nameLabel.text = cell.productName
        quantityLabel.text = cell.quantity
        productImage.loadImage(withId: cell.imageId, path: .productImage)
    }
}
