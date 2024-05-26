//
//  SingleCollectionViewCell.swift
//  FoodZ
//
//  Created by surexnx on 28.03.2024.
//

import UIKit

class SingleCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "SingleCollectionViewCell"

    // MARK: Internal properties

    var proccesedChangeLike: (() -> Void)?

    // MARK: Private properties

    private lazy var productNameLabel = UILabel()
    private lazy var productCategoryLabel = UILabel()
    private lazy var productCompoundLabel = UILabel()
    private lazy var productRatingLabel = UILabel()
    private lazy var productWaitingTimerLabel = UILabel()
    private lazy var productPriceLabel = UILabel()
    private lazy var productWaltingTimerImage = UIImageView()
    private lazy var productRatingImage = UIImageView()
    private lazy var productSavedButton = UIButton()
    private lazy var productImage = CustomImageView()


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
        contentView.addSubview(productImage)
        contentView.addSubview(productSavedButton)

        productImage.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.leading.bottom.top.equalToSuperview()
        }

        lowerStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        productSavedButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalTo(productSavedButton.snp.height)
            make.trailing.equalTo(productImage.snp.trailing).inset(5)
        }
    }

    private func setupDisplay() {
        backgroundColor = AppColor.background.color
        productImage.tintColor = AppColor.title.color
        productImage.contentMode = .scaleAspectFill
        productWaltingTimerImage.tintColor = AppColor.title.color
        productRatingImage.tintColor = AppColor.title.color
        productPriceLabel.textColor = AppColor.primary.color
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        layer.shadowRadius = 8.0
        layer.cornerRadius = contentView.layer.cornerRadius
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 5)

        setupButton()
    }

    private func setupButton() {
        let action = UIAction { [weak self] _ in
            guard let self = self,
                  let proccesedChangeLike = proccesedChangeLike
            else { return }
            proccesedChangeLike()
        }
        productSavedButton.addAction(action, for: .touchUpInside)
        productSavedButton.backgroundColor = AppColor.background.color
        productSavedButton.tintColor = AppColor.title.color
        productSavedButton.layer.cornerRadius = contentView.frame.height / (2 / 0.2)
        productSavedButton.clipsToBounds = true
    }

    private func changeLike(like: Bool) {
        if like {
            productSavedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            productSavedButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }

    // MARK: Internal methods

    func configure(with cell: ProductCell) {
        productNameLabel.text = cell.productName
        productPriceLabel.text = String(cell.productPrice)
        productRatingLabel.text = String(cell.productRating)
        productCategoryLabel.text = cell.productCategory
        productCompoundLabel.text = cell.productCompound
        productWaitingTimerLabel.text = String(cell.productWaitingTime) + "min"
        productImage.loadImage(withId: cell.productImageId, path: .productImage)
        productWaltingTimerImage.image = UIImage(systemName: "stopwatch.fill")
        productRatingImage.image = UIImage(systemName: "star.fill")
        productSavedButton.setImage(UIImage(systemName: "heart"), for: .normal)
        changeLike(like: cell.productSavedStatus)
    }
}
