//
//  SelfProductCell.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import UIKit

protocol SelfConfiguringDraftsCell {
    static var reuseIdentifier: String { get }
}

final class DraftsProductCell: UICollectionViewCell, SelfConfiguringDraftsCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "DraftsProductCell"

    // MARK: Private properties

    private lazy var productNameLabel = UILabel()
    private lazy var productPriceLabel = UILabel()
    private lazy var label = UILabel()
    private lazy var editImage = UIImageView()
    private lazy var productImage = UIImageView()
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
           productPriceLabel,
           productNameLabel,
           label
        ])
        contentView.addSubview(stackView)
        contentView.addSubview(editImage)
        contentView.addSubview(productImage)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        productImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        editImage.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(editImage.snp.leading)
        }
    }

    private func setupDisplay() {

    }

    // MARK: Internal methods

    func configure(with cell: DraftsProduct) {
        if let data = cell.image {
            productImage.image = UIImage(data: data)
        }
        productNameLabel.text = cell.name
        productPriceLabel.text = cell.price
        label.text = cell.time
    }
}
