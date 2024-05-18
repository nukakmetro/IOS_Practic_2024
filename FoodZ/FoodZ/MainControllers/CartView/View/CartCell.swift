//
//  CartCell.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import UIKit
import SnapKit

protocol CartCellDelegate: AnyObject {
    func proccesedTappedButtonReduce(id: Int, _ input: CartCellInput)
    func proccesedTappedButtonIncrease(id: Int, _ input: CartCellInput)
    func proccesedTappedButtonTrash(id: Int, _ input: CartCellInput)
    func proccesedTappedButtonSave(id: Int, _ input: CartCellInput)
}

protocol CartCellInput: AnyObject {
    func proccesedTappedButtonReduce(quantity: String, price: String)
    func proccesedTappedButtonIncrease(quantity: String, price: String)
    func proccesedTappedButtonSave()
}

final class CartCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "CartCell"

    // MARK: Internal properties

    var id: Int?
    weak var delegate: CartCellDelegate?

    // MARK: Private properties

    private lazy var quantityLabel = UILabel()
    private lazy var nameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var trashButton = UIButton()
    private lazy var reduceButton = UIButton()
    private lazy var increaseButton = UIButton()
    private lazy var saveButton = UIButton()
    private lazy var image = CustomImageView()

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
        var quantityStackView: UIStackView = UIStackView(arrangedSubviews: [reduceButton, quantityLabel, increaseButton])
        quantityStackView.axis = .horizontal
        quantityStackView.alignment = .center
        quantityStackView.spacing = 5
        quantityStackView.translatesAutoresizingMaskIntoConstraints = false

        var buttonStackView: UIStackView = UIStackView(arrangedSubviews: [saveButton, trashButton])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.spacing = 5
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        var textStackView: UIStackView = UIStackView(arrangedSubviews: [priceLabel, nameLabel, descriptionLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 10
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(quantityStackView)
        contentView.addSubview(buttonStackView)
        contentView.addSubview(image)
        contentView.addSubview(textStackView)

        textStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.top.equalToSuperview().inset(10)
        }

        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }

        quantityStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(20)
        }
    }

    private func setupDisplay() {
        contentView.backgroundColor = AppColor.background.color
        setupImage()
        setupSaveButton()
        setupTrashButton()
        setupReduceButton()
        setupIncreaseButton()
        setupQuantityLabel()
        setupDescriptionLabel()
        setupNameLabel()
        setupPriceLabel()
    }

    private func changeLike(like: Bool) {
        
    }

    private func setupPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 17)
    }

    private func setupNameLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .lightGray
    }

    private func setupQuantityLabel() {
        quantityLabel.backgroundColor = AppColor.cartBackground.color
        quantityLabel.layer.cornerRadius = 5
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupImage() {
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupTrashButton() {
        let action = UIAction { [weak self] _ in
            guard
                let self = self,
                let id = id
            else { return }

            delegate?.proccesedTappedButtonTrash(id: id, self)
        }
        trashButton.addAction(action, for: .touchUpInside)
        trashButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        trashButton.layer.cornerRadius = 5
        trashButton.backgroundColor = AppColor.cartBackground.color
        trashButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupReduceButton() {
        let action = UIAction { [weak self] _ in
            guard
                let self = self,
                let id = id
            else { return }

            delegate?.proccesedTappedButtonReduce(id: id, self)
        }
        reduceButton.addAction(action, for: .touchUpInside)
        reduceButton.setImage(UIImage(systemName: "minus"), for: .normal)
        reduceButton.layer.cornerRadius = 5
        reduceButton.backgroundColor = AppColor.cartBackground.color
        reduceButton.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupIncreaseButton() {
        let action = UIAction { [weak self] _ in
            guard
                let self = self,
                let id = id
            else { return }

            delegate?.proccesedTappedButtonIncrease(id: id, self)
        }
        increaseButton.addAction(action, for: .touchUpInside)
        increaseButton.setImage(UIImage(systemName: "plus"), for: .normal)
        increaseButton.layer.cornerRadius = 5
        increaseButton.backgroundColor = AppColor.cartBackground.color
        increaseButton.translatesAutoresizingMaskIntoConstraints = false

    }

    private func setupSaveButton() {
        let action = UIAction { [weak self] _ in
            guard
                let self = self,
                let id = id
            else { return }

            delegate?.proccesedTappedButtonSave(id: id, self)
        }
        saveButton.addAction(action, for: .touchUpInside)
        saveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = AppColor.cartBackground.color
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Internal methods

    func configure(with cell: CartProduct) {
        image.loadImage(withId: cell.productImageId, path: .productImage)
        priceLabel.text = cell.productPrice
        nameLabel.text = cell.productName
        quantityLabel.text = cell.quantity
        descriptionLabel.text = cell.productDescription
        id = cell.cartItemId
    }
}

// MARK: - CartCellInput

extension CartCell: CartCellInput {
    func proccesedTappedButtonReduce(quantity: String, price: String) {
        quantityLabel.text = quantity
        priceLabel.text = price
    }

    func proccesedTappedButtonIncrease(quantity: String, price: String) {
        quantityLabel.text = quantity
        priceLabel.text = price
    }

    func proccesedTappedButtonSave() {

    }
}
