//
//  ProfileMainHeaderCell.swift
//  FoodZ
//
//  Created by surexnx on 23.04.2024.
//

import UIKit

class ProfileMainHeaderCell: UICollectionViewCell {

    // MARK: Private properties

    private lazy var usernameLabel = UILabel()
    private lazy var userImage = CustomImageView()
    private lazy var userNumberLabel = UILabel()
    private lazy var addressLabel = UILabel()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        setupDisplay()
        userImage.image = UIImage(systemName: "person.fill")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraints() {
        let textStackView: UIStackView = UIStackView(arrangedSubviews: [usernameLabel, userNumberLabel, addressLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .center
        textStackView.distribution = .fillEqually
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(userImage)
        contentView.addSubview(textStackView)

        userImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(userImage.snp.height)
            make.top.equalToSuperview().inset(20)
        }
        textStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userImage.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }

    private func setupDisplay() {
        setupImage()
        setupLabel()
    }

    private func setupImage() {
        userImage.contentMode = .scaleAspectFit
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = contentView.frame.height / 4
    }

    private func setupLabel() {

    }

    // MARK: Internal methods

    func configure(with cell: ProfileMainHeader) {
        usernameLabel.text = cell.username
        userNumberLabel.text = cell.number
        addressLabel.text = cell.address
        if let imageId = cell.imageId {
            userImage.loadImage(withId: imageId, path: .userImage)
        }
        userImage.image = UIImage(named: "Cat")
    }
}

// MARK: - ProfileSelfConfiguringCell

extension ProfileMainHeaderCell: ProfileSelfConfiguringCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

