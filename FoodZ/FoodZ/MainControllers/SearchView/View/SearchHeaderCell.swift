//
//  SearchHeader.swift
//  FoodZ
//
//  Created by surexnx on 07.04.2024.
//

import Foundation
import UIKit

final class SearchHeaderCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static var reuseIdentifier: String = "SearchHeaderCell"

    // MARK: Internal properties

    var proccesedButtonTapToBack: (() -> Void)?
    var proccesedInputTextToSearch: ((String?) -> Void)?

    // MARK: Private properties

    private var timerTextField: Timer?

    private lazy var titleLabel: UILabel = {
        return UILabel()
    }()

    private lazy var backButton: UIButton = {
        let action = UIAction { [weak self] _ in
            guard let self = self,
                  let proccesedButtonTapToBack = proccesedButtonTapToBack
            else { return }
            proccesedButtonTapToBack()
        }

        var button = UIButton(primaryAction: action)
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return button
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Поиск"
        textField.layer.cornerRadius = frame.height * 0.3 / 2
        textField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.clipsToBounds = true
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    // MARK: Initializator

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConsraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    @objc private func textFieldDidChange(_ textField: UITextField) {
        timerTextField?.invalidate()

        timerTextField = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }

    @objc private func timerAction() {
        guard let proccesedInputTextToSearch = proccesedInputTextToSearch else { return }
        proccesedInputTextToSearch(self.searchTextField.text)
    }

    private func makeConsraints() {

        titleLabel.text = "Поиск"
        titleLabel.textColor = AppColor.secondary.color
        backButton.tintColor = AppColor.secondary.color
        backgroundColor = AppColor.primary.color
        contentView.addSubview(searchTextField)
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(15)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        searchTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
}

extension SearchHeaderCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timerTextField?.invalidate()
        timerTextField = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] _ in
            guard let self = self,
                  let proccesedInputTextToSearch = proccesedInputTextToSearch
            else { return }
            proccesedInputTextToSearch(searchTextField.text)
        })
        return true
    }
}
