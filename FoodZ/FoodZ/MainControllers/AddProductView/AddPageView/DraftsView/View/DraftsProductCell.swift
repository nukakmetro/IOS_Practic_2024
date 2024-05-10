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
    private var id: UUID?

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
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        editImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }

    private func setupDisplay() {
        editImage.image = UIImage(systemName: "pencil")
        productImage.contentMode = .scaleToFill
    }

    // MARK: Internal methods

    func getId() -> UUID? {
        return id
    }

    func configure(with cell: DraftsProduct) {
        if let data = cell.image {
            productImage.image = UIImage(data: data)
        } else {
            productImage.image = UIImage(systemName: "photo")
        }
        productNameLabel.text = cell.name
        productPriceLabel.text = cell.price
        label.text = cell.time
        id = cell.id
    }
}
