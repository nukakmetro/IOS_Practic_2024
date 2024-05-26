//
//  SingleMainCollectionViewCell.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import UIKit
import SnapKit

final class HomeCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "HomeCell"

    // MARK: Internal properties

    var proccesedChangeLike: (() -> Void)?
    var id: Int?

    // MARK: Private properties

    private var like: Bool?
    private lazy var productNameLabel = UILabel()
    private lazy var productCategoryLabel = UILabel()
    private lazy var productCompoundLabel = UILabel()
    private lazy var productRatingLabel = UILabel()
    private lazy var productWaitingTimerLabel = UILabel()
    private lazy var productPriceLabel = UILabel()
    private lazy var productSavedButton = UIButton()
    private lazy var productImage = CustomImageView()
    private lazy var productWaltingTimerImage = UIImageView()
    private lazy var productRatingImage = UIImageView()

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraint()
        setupDisplay()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func makeConstraint() {
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
            make.height.equalToSuperview().multipliedBy(0.4)
            make.leading.trailing.top.equalToSuperview()
        }
        lowerStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview()
        }

        productSavedButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalTo(productSavedButton.snp.height)
        }
    }

    private func setupDisplay() {
        let action = UIAction { [weak self] _ in

            guard
                let self = self,
                let proccesedChangeLike = proccesedChangeLike
            else { return }

            proccesedChangeLike()
        }
        productSavedButton.addAction(action, for: .touchUpInside)
        productSavedButton.clipsToBounds = true
        productSavedButton.layer.cornerRadius = contentView.frame.height / (2 / 0.15)
        backgroundColor = AppColor.background.color
        productImage.tintColor = AppColor.title.color
        productImage.contentMode = .scaleAspectFill

        productWaltingTimerImage.tintColor = AppColor.title.color
        productRatingImage.tintColor = AppColor.title.color
        productPriceLabel.textColor = AppColor.primary.color
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        layer.shadowRadius = 8.0
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.10
        layer.cornerRadius = contentView.layer.cornerRadius
        layer.shadowOffset = CGSize(width: 0, height: 5)
        productSavedButton.backgroundColor = AppColor.background.color
        productSavedButton.tintColor = AppColor.title.color
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
        changeLike(like: cell.productSavedStatus)
        productRatingImage.image = UIImage(systemName: "star.fill")
        like = cell.productSavedStatus
        id = cell.productId
    }
}
