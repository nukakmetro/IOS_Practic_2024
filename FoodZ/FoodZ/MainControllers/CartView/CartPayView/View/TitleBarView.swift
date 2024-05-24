//
//  TitleBarView.swift
//  FoodZ
//
//  Created by surexnx on 24.05.2024.
//

import UIKit
import SnapKit

final class TitleBarView: UIView {

    // MARK: Internal properties

    var closeView: (() -> Void)?

    // MARK: Private properties

    private lazy var closeButton = UIButton()
    private lazy var titleLabel = UILabel()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDisplay()
        makeContraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeContraint() {
        addSubview(closeButton)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    private func setupDisplay() {
        let action = UIAction { [weak self] _ in
            guard let self = self,
                  let closeView = closeView
            else { return }
            closeView()
        }
        closeButton.addAction(action, for: .touchUpInside)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black

        titleLabel.font = .systemFont(ofSize: 14)
    }

    // MARK: Internal methods

    func configure(title: String, color: UIColor?) {
        titleLabel.text = title
        backgroundColor = color
    }
}
