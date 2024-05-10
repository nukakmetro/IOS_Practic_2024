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
        textField.delegate = self
    }

    // MARK: Internal methods

    func getData() -> FillingData {
        if let textField = textField.text, textField.isEmpty {
            self.textField.backgroundColor = .red
        }
        return FillingData(name: label.text, value: textField.text, error: false)
    }

    func configure(with data: FillingData) {
        label.text = data.name
        textField.text = data.value
        switch data.error {
        case true:
            textField.backgroundColor = .red
        case false:
            textField.backgroundColor = .white
        }
    }
}

extension FillingCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = .white
    }
}
