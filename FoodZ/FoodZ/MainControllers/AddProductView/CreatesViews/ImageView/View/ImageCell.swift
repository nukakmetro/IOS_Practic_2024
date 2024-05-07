//
//  ImageCell.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import UIKit
import SnapKit

protocol ImageCellDelegate: AnyObject {
    func proccesedTappedDelete(_ indexPathRow: Int)
}

final class ImageCell: UICollectionViewCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "ImageCell"

    // MARK: Internal properties

    weak var delegate: ImageCellDelegate?

    // MARK: Private properties

    private lazy var image = UIImageView()
    private lazy var deleteButton = UIButton()

    private var indexPathRow: Int?

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
        contentView.addSubview(image)
        contentView.addSubview(deleteButton)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.bottom.equalTo(image.snp.top).offset(10)
        }

    }

    private func setupDisplay() {
        setupButton()
        setupImage()
    }

    private func setupButton() {
        let action = UIAction { [weak self] _ in
            guard 
                let self = self,
                let indexPathRow = indexPathRow
            else { return }
            delegate?.proccesedTappedDelete(indexPathRow)
        }
        deleteButton.addAction(action, for: .touchUpInside)
        deleteButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }

    private func setupImage() {
        image.contentMode = .scaleAspectFit
    }

    // MARK: Internal methods

    func configure(image: UIImage, indexPathRow: Int) {
        self.image.image = image
    }
}
