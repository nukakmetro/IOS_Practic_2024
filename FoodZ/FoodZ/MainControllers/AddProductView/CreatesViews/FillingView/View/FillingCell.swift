//
//  FillingCell.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import UIKit
import SnapKit

final class FillingCell: UICollectionViewCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "FillingCell"

    // MARK: Private properties

    private lazy var label = UILabel()
    private lazy var textField = UITextField()
    private var fillingData: FillingData?
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
        contentView.addSubview(label)
        contentView.addSubview(textField)

        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(label.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }

    }

    private func setupDisplay() {
        textField.placeholder = "Введите значение"
        textField.borderStyle = .roundedRect
    }

    // MARK: Internal methods

    func getData() -> FillingData {
        return FillingData(name: label.text, value: textField.text, error: false)
    }

    func configure(with data: FillingData) {
        label.text = data.name
        textField.text = data.value
        fillingData = data
        switch data.error {
        case true:
            textField.tintColor = .red
        case false:
            textField.tintColor = .white
        }
    }
}

extension FillingCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .white
    }
}
