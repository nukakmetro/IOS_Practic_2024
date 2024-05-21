//
//  SelfProductInformationCell.swift
//  FoodZ
//
//  Created by surexnx on 15.05.2024.
//

import UIKit
import SnapKit

final class SelfProductInformationCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "SelfProductInformationCell"

    // MARK: Private properties

    private lazy var content = UIView()
    private lazy var productNameLabel = UILabel()
    private lazy var productPriceLabel = UILabel()
    private lazy var productUsernameLabel = UILabel()
    private lazy var productCategoryLabel = UILabel()
    private lazy var addressLabel = UILabel()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        makeConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraint() {
        let miniStackView = UIStackView(arrangedSubviews: [productUsernameLabel, productCategoryLabel])
        miniStackView.axis = .vertical
        miniStackView.alignment = .leading

        contentView.addSubview(content)
        contentView.addSubview(miniStackView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(addressLabel)

        content.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        miniStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }

        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(miniStackView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
        }

        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(productPriceLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
        }
    }

    private func setupContent() {
        content.backgroundColor = .lightGray
        content.layer.cornerRadius = 10
        productUsernameLabel.font = .systemFont(ofSize: 14)
        productCategoryLabel.font = .systemFont(ofSize: 14)
        productNameLabel.font = .systemFont(ofSize: 19)
        addressLabel.font = .systemFont(ofSize: 14)
    }

    // MARK: Internal methods

    func configure(cell: InformationCellData) {
        productNameLabel.text = cell.productName
        productCategoryLabel.text = cell.productCategory
        productUsernameLabel.text = cell.productUsername
        productPriceLabel.text = cell.productPrice
        addressLabel.text = cell.address
    }
}
