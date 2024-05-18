//
//  SingleMainCollectionViewCell.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import UIKit
import SnapKit

protocol HomeCellDelegate: AnyObject {
    func proccesedTappedLike(id: Int, input: HomeCellInput)
}

protocol HomeCellInput: AnyObject {
    func proccesedChangeLike(like: Bool)
    func proccesedChangeLikeError()
}

final class HomeCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Internal static properties

    static let reuseIdentifier: String = "HomeCell"

    // MARK: Internal properties

    var id: Int?
    weak var delegate: HomeCellDelegate?

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
    private lazy var containerView: UIView = {
        var containerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.45))
        containerView.addSubview(productImage)
        containerView.backgroundColor = UIColor.clear
        containerView.addSubview(productSavedButton)
        containerView.bringSubviewToFront(productSavedButton)
        return containerView
    }()

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
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
            make.leading.trailing.top.equalToSuperview()
        }
        lowerStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
    }

    private func setupDisplay() {
        productImage.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        let action = UIAction { [weak self] _ in
            self?.like?.toggle()
            guard
                let self = self,
                let like = like,
                let id = id
            else { return }

            changeLike(like: like)
            delegate?.proccesedTappedLike(id: id, input: self)
        }
        productSavedButton.addAction(action, for: .touchUpInside)
        productSavedButton.frame = CGRect(x: Int(containerView.bounds.maxX - 30), y: 10, width: Int(bounds.width) / 8, height: Int(bounds.width) / 8)
        // productImage.contentMode = .scaleToFill
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
// MARK: - HomeCellInput

extension HomeCell: HomeCellInput {
    func proccesedChangeLikeError() {
        like?.toggle()
        guard let like = like else { return }
        changeLike(like: like)
    }
    
    func proccesedChangeLike(like: Bool) {
        changeLike(like: like)
        self.like = like
    }
}
