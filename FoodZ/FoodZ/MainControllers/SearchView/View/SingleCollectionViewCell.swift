//
//  SingleCollectionViewCell.swift
//  FoodZ
//
//  Created by surexnx on 28.03.2024.
//

import UIKit

class SingleCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal properties

    static let reuseIdentifier: String = "SingleCollectionViewCell"

    // MARK: Private properties

    private lazy var productNameLabel = UILabel()
    private lazy var productCategoryLabel = UILabel()
    private lazy var productCompoundLabel = UILabel()
    private lazy var productRatingLabel = UILabel()
    private lazy var productWaitingTimerLabel = UILabel()
    private lazy var productPriceLabel = UILabel()
    private lazy var productWaltingTimerImage = UIImageView()
    private lazy var productRatingImage = UIImageView()

    private lazy var productSavedButton: UIButton = {
        let action = UIAction { _ in

        }
        var button = UIButton(primaryAction: action)

        return button
    }()
    private lazy var productImage = UIImageView()

    private lazy var containerView: UIView = {
        var containerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width * 0.45, height: bounds.height))
        containerView.addSubview(productImage)
        containerView.backgroundColor = UIColor.clear
        containerView.addSubview(productSavedButton)
        containerView.bringSubviewToFront(productSavedButton)
        return containerView
    }()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDisplay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupLayout() {

        let ratingStackView = UIStackView(arrangedSubviews: [
            productWaltingTimerImage,
            productWaitingTimerLabel,
            productRatingImage,
            productRatingLabel
        ])

        ratingStackView.axis = .horizontal
        ratingStackView.alignment = .center
        let lowerStackView = UIStackView(arrangedSubviews: [
            productNameLabel,
            productCategoryLabel,
            productCompoundLabel,
            ratingStackView,
            productPriceLabel
        ])
        lowerStackView.axis = .vertical
        lowerStackView.distribution = .fillEqually
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lowerStackView)
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(1)
            make.bottom.leading.top.equalToSuperview()
        }
        lowerStackView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.trailing)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }

    private func setupDisplay() {
        productSavedButton.frame = CGRect(x: Int(containerView.bounds.maxX) - 30, y: 10, width: Int(bounds.width) / 8, height: Int(bounds.width) / 8)
        productImage.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        backgroundColor = AppColor.background.color
        productImage.tintColor = AppColor.title.color
        productWaltingTimerImage.tintColor = AppColor.title.color
        productRatingImage.tintColor = AppColor.title.color
        productPriceLabel.textColor = AppColor.primary.color
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        layer.shadowRadius = 8.0
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        productSavedButton.backgroundColor = AppColor.background.color
        productSavedButton.tintColor = AppColor.title.color
        productSavedButton.layer.cornerRadius = productSavedButton.frame.width / 2
    }

    // MARK: Internal methods

    func configure(with cell: Product) {
        productNameLabel.text = cell.productName
        productPriceLabel.text = String(cell.productPrice)
        productRatingLabel.text = String(cell.productRating)
        productCategoryLabel.text = cell.productCategory
        productCompoundLabel.text = cell.productCompound
        productWaitingTimerLabel.text = String(cell.productWaitingTime) + "min"
        productImage.image = UIImage(named: cell.productImages.first?.imageName ?? "Cat")
        productWaltingTimerImage.image = UIImage(systemName: "stopwatch.fill")
        productRatingImage.image = UIImage(systemName: "star.fill")
        productSavedButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
}
