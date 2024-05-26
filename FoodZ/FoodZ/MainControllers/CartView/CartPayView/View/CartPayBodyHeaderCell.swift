//
//  CartPayBodyHeaderCell.swift
//  FoodZ
//
//  Created by surexnx on 23.05.2024.
//

import UIKit
import SnapKit

final class CartPayBodyHeaderCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "CartPayBodyHeaderCell"

    // MARK: Private properties

    private lazy var addressLabel = UILabel()

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

        contentView.addSubview(addressLabel)

        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
    }

    private func setupDisplay() {
        contentView.backgroundColor = AppColor.background.color
        setupAddressLabel()
    }

    private func setupAddressLabel() {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.font = .systemFont(ofSize: 15)
    }


    // MARK: Internal methods

    func configure(with cell: CartPayHeader) {
        addressLabel.text = cell.address
    }
}
