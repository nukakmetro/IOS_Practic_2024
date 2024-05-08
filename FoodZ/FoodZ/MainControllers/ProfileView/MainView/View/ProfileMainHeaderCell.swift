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
        contentView.addSubview(userImage)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(userNumberLabel)

        userImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(userImage.snp.height)
            make.top.equalToSuperview().inset(20)
        }
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userImage.snp.bottom).offset(20)
        }
        userNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
        }
    }

    private func setupDisplay() {
        setupImage()
        setupLabel()
    }

    private func setupImage() {
        userImage.contentMode = .scaleAspectFit
        userImage.layer.cornerRadius = userImage.layer.frame.width / 2
    }
    private func setupLabel() {

    }

    // MARK: Internal methods

    func configure(with cell: ProfileMainHeader) {
        usernameLabel.text = cell.username
        userNumberLabel.text = cell.number
        userImage.loadImage(withId: cell.id, userImage: .userImage)
    }
}

// MARK: ProfileSelfConfiguringCell protocol

extension ProfileMainHeaderCell: ProfileSelfConfiguringCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

