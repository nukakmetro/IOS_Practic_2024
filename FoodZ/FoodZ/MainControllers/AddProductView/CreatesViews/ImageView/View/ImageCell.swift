//
//  ImageCell.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import UIKit
import SnapKit

protocol ImageCellDelegate: AnyObject {
    func proccesedTappedDelete(_ id: UUID)
}

final class ImageCell: UICollectionViewCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "ImageCell"

    // MARK: Internal properties

    weak var delegate: ImageCellDelegate?

    // MARK: Private properties

    private lazy var image = UIImageView()
    private lazy var deleteButton = UIButton()

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
        contentView.addSubview(image)
        contentView.addSubview(deleteButton)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
        }

    }

    private func setupDisplay() {
        setupButton()
        setupImage()
        backgroundColor = .gray
    }

    private func setupButton() {
        let action = UIAction { [weak self] _ in
            guard
                let self = self,
                let id = id
            else { return }
            delegate?.proccesedTappedDelete(id)
        }
        deleteButton.addAction(action, for: .touchUpInside)
        deleteButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        deleteButton.tintColor = .black
        deleteButton.backgroundColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupImage() {
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Internal methods

    func configure(image: UIImage, id: UUID) {
        self.image.image = image
        self.id = id
    }
}
