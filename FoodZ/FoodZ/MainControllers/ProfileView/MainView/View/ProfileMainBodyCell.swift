//
//  ProfileMainCell.swift
//  FoodZ
//
//  Created by surexnx on 22.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class ProfileMainBodyCell: UICollectionViewCell, ProfileSelfConfiguringCell {

    // MARK: Private properties

    private lazy var cellName = UILabel()
    private lazy var cellImage = UIImageView()
    private lazy var cellArrow = UIImageView()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        setupDisplay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraints() {

        contentView.addSubview(cellName)
        contentView.addSubview(cellImage)
        contentView.addSubview(cellArrow)

        cellImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.centerX.equalTo(contentView.snp.leading).inset(30)
        }

        cellName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(cellImage.snp.trailing).offset(20)
        }

        cellArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupDisplay() {
        cellArrow.image = UIImage(systemName: "chevron.right")
    }

    // MARK: Internal methods

    func configure(with cell: ProfileMainBody) {
        self.cellImage.image = UIImage(systemName: cell.cellImageName)
        self.cellName.text = cell.cellName
    }
}

// MARK: ProfileSelfConfiguringCell protocol

extension ProfileMainBodyCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
