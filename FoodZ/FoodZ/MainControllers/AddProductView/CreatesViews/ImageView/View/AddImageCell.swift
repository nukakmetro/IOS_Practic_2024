//
//  AddImageCell.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import UIKit
import SnapKit

final class AddImageCell: UICollectionViewCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "AddImageCell"

    // MARK: Private properties

    private lazy var image = UIImageView()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        makeConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraint() {
        contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    private func setupImage() {
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "photo.badge.plus")
    }
}
