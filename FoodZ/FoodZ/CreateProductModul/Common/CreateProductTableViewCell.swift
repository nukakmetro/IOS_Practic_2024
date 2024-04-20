//
//  CreateProductTableViewCell.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import UIKit
import SnapKit

final class CreateProductTableViewCell: UITableViewCell {

    // MARK: Private properties

    private lazy var label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeConstraints() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
    }
    private func setupLabel() {
        label.textColor = AppColor.title.color
    }

    func configureForHeader() {
        label.font = UIFont.systemFont(ofSize: 20)
    }
    func configureForCell() {
        label.font = UIFont.systemFont(ofSize: 16)
    }
}

extension CreateProductTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
