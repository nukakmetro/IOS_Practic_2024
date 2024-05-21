//
//  CartPayViewController.swift
//  FoodZ
//
//  Created by surexnx on 19.05.2024.
//

import UIKit
import Combine

final class CartPayViewController<ViewModel: CartPayViewModeling>: UIViewController, UICollectionViewDelegate {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<CartSectionType, CartCellType>?
    private var sections: [CartSectionType]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var totalPriceLabel = UILabel()
    private lazy var payButton = UIButton()

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            CartCell.self,
            forCellWithReuseIdentifier: CartCell.reuseIdentifier
        )
        collectionView.backgroundColor = AppColor.cartBackground.color
        collectionView.delegate = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return collectionView
    }()

    // MARK: Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.sections = []
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        //createDataSource()
        configureIO()
        viewModel.trigger(.onDidLoad)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: Private methods

    @objc private func didPullToRefresh() {
        DispatchQueue.global().async {
            self.viewModel.trigger(.onReload)
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }

    private func configureIO() {
        viewModel
            .stateDidChange
            .sink { [weak self] _ in
                self?.render()
            }
            .store(in: &cancellables)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            break
        case .content(let dispayData, let viewData):
            setupDisplayData(viewData: viewData)
            sections = dispayData
            reloadData()
        case .error:
            break
        }
    }

    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        return cell
    }

//    private func createDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<CartSectionType, CartCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
//            guard let self = self else { return UICollectionViewCell() }
//
//
//        }
//    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<CartSectionType, CartCellType>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .bodySection(_, let data):
                snapshot.appendItems(data, toSection: section)
            }
        }

        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return self?.createBodyTableSection() }
            let section = sections[sectionIndex]

            switch section {

            case .bodySection:
                return createBodyTableSection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private func createBodyTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none

        return layoutSection
    }

    private func makeConstraints() {
        view.backgroundColor = AppColor.primary.color

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [totalPriceLabel, payButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = AppColor.background.color

        view.addSubview(collectionView)
        view.addSubview(stackView)

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }

    private func setupDisplayData(viewData: CartViewData) {

        totalPriceLabel.text = String(viewData.totalPrice)

        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            payButton.isEnabled = false
           // viewModel.trigger(.proccesedTappedButtonPay)
        }
        payButton.isEnabled = true
        payButton.removeTarget(self, action: nil, for: .allEvents)

        if viewData.totalPrice == 0 {
            payButton.isEnabled = false
            payButton.setTitle("Корзина пустая", for: .normal)
            payButton.backgroundColor = .red
        } else {
            payButton.addAction(action, for: .touchUpInside)
            payButton.backgroundColor = .blue
            payButton.setTitle("Перейти к оформлению", for: .normal)
        }
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CartCell {
            if let id = cell.id {
                //viewModel.trigger(.proccesedTappedButtonCell(id: id))
            }
        }
    }
}