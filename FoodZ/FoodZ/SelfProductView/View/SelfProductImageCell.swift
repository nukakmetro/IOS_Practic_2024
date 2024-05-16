//
//  ImageCell.swift
//  FoodZ
//
//  Created by surexnx on 13.05.2024.
//

import UIKit
import SnapKit

final class SelfProductImageCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "SelfProductImageCell"

    // MARK: Private properties

    private lazy var image = CustomImageView()

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
            make.edges.equalToSuperview()
        }
    }

    private func setupImage() {
        image.contentMode = .scaleAspectFit
    }

    // MARK: Internal methods

    func configure(imageId: Int) {
        image.loadImage(withId: imageId, path: .productImage)
    }
}
