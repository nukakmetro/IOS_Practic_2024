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
    private var dataSource: UICollectionViewDiffableDataSource<CartPaySectionType, CartPayCellType>?
    private var sections: [CartPaySectionType]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var totalPriceLabel = UILabel()
    private lazy var payButton = UIButton()
    private lazy var stackView = UIStackView(arrangedSubviews: [totalPriceLabel, payButton])
    private lazy var titlebar = TitleBarView()
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            CartPayBodyHeaderCell.self,
            forCellWithReuseIdentifier: CartPayBodyHeaderCell.reuseIdentifier
        )
        collectionView.register(
            CartPayBodyCell.self,
            forCellWithReuseIdentifier: CartPayBodyCell.reuseIdentifier
        )
        collectionView.register(
            CartPayFooterCell.self,
            forCellWithReuseIdentifier: CartPayFooterCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.backgroundColor = AppColor.cartBackground.color
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
        createDataSource()
        configureIO()
        setupDisplay()
        viewModel.trigger(.onDidLoad)
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
        case .content(let dispayData, let displayData):
            setupDisplayData(totalPrice: displayData)
            sections = dispayData
            reloadData()
            isLastCellVisible()
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

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CartPaySectionType, CartPayCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .bodyCell(let data):
                var cell = configure(CartPayBodyCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            case .bodyHeaderCell(let data):
                var cell = configure(CartPayBodyHeaderCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            case .footerCell(let data):
                var cell = configure(CartPayFooterCell.self, for: indexPath)
                cell.configure(with: data)
                cell.proccesedTappedButtonPay = {
                    self.viewModel.trigger(.proccesedTappedButtonPay)
                }
                return cell
            }
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<CartPaySectionType, CartPayCellType>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .bodySection(_, let data):
                snapshot.appendItems(data, toSection: section)
            case .bodyHeaderSection(_, let data):
                snapshot.appendItems([data], toSection: section)
            case .footerSection(_, let data):
                snapshot.appendItems([data], toSection: section)
            }
        }

        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return self?.createHeaderTableSection() }
            let section = sections[sectionIndex]

            switch section {

            case .bodySection:
                return createBodyTableSection()
            case .bodyHeaderSection:
                return createHeaderTableSection()
            case .footerSection:
                return createFooterTableSection()
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
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.05))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none

        return layoutSection
    }

    private func createHeaderTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none

        return layoutSection
    }

    private func createFooterTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1))
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

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = AppColor.background.color

        view.addSubview(collectionView)
        view.addSubview(stackView)
        view.addSubview(titlebar)

        titlebar.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalToSuperview().multipliedBy(0.05)
        }

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(titlebar.snp.bottom)
            make.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }

    private func setupTitleBar() {
        titlebar.configure(title: "Оформление заказа", color: nil)
        titlebar.closeView = {
            self.viewModel.trigger(.onClose)
        }
    }

    private func setupDisplay() {

        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.trigger(.proccesedTappedButtonPay)
        }
        payButton.addAction(action, for: .touchUpInside)
        payButton.setTitle("Оплатить", for: .normal)
        payButton.backgroundColor = .blue
        payButton.layer.cornerRadius = 10

        setupTitleBar()
    }

    private func setupDisplayData(totalPrice: String) {
        totalPriceLabel.text = totalPrice
    }

    // MARK: - UICollectionViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isLastCellVisible()
    }

    private func isLastCellVisible() {
        let lastSectionIndex = sections.endIndex - 1
        let lastIndexPath = IndexPath(item: 0, section: lastSectionIndex)
        let isLastCellVisible = collectionView.indexPathsForVisibleItems.contains(lastIndexPath)

        if isLastCellVisible {
            UIView.animate(withDuration: 0.1, animations: {
                self.stackView.frame.origin.y = self.view.frame.height + self.stackView.frame.height
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.stackView.frame.origin.y = self.view.frame.height - self.stackView.frame.height - 10
            })
        }
    }
}
