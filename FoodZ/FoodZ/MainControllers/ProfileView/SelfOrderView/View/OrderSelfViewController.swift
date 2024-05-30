//
//  SelfOrderViewController.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import UIKit
import Combine
import SnapKit

final class OrderSelfViewController<ViewModel: OrderSelfViewModeling>: UIViewController, UICollectionViewDelegateFlowLayout {

    // MARK: Private properties

    private var sections: [OrderSelfSectionType]
    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<OrderSelfSectionType, OrderSelfCellType>?
    private var cancellables: Set<AnyCancellable> = []
    weak var segmentControlInput: SelfProductImageGropeFooterInput?
    private lazy var changeStatusButton = UIButton()
    private var like: Bool?

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white

        collectionView.register(
            OrderSelfItemCell.self,
            forCellWithReuseIdentifier: OrderSelfItemCell.reuseIdentifier
        )
        collectionView.register(
            OrderSelfHeaderCell.self,
            forCellWithReuseIdentifier: OrderSelfHeaderCell.reuseIdentifier
        )

        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return collectionView
    }()

    // MARK: Initialization

    init( viewModel: ViewModel) {
        self.sections = []
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.trigger(.onDidLoad)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConstraints()
        createDataSource()
        configureIO()
        reloadData()
        viewModel.trigger(.onLoad)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = AppColor.secondary.color
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
        case .content(let dispayData, let displayViewData):
            setupDisplayView(viewData: displayViewData)
            self.sections = dispayData
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

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<OrderSelfSectionType, OrderSelfCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .bodyCell(let data):
                let cell = configure(OrderSelfItemCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            case .headerCell(let data):
                let cell = configure(OrderSelfHeaderCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            }
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<OrderSelfSectionType, OrderSelfCellType>()
        snapshot.appendSections(sections)
        for section in sections {
            switch section {
            case .bodySection(_, let items):
                snapshot.appendItems(items, toSection: section)
            case .headerSection(_, let item):
                snapshot.appendItems([item], toSection: section)
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
            case .headerSection:
                return createHeaderTableSection()
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
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
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

    private func makeConstraints() {
        view.backgroundColor = AppColor.secondary.color
        view.addSubview(collectionView)
        view.addSubview(changeStatusButton)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        changeStatusButton.translatesAutoresizingMaskIntoConstraints = false

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }

        changeStatusButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }

    private func setupDisplayView(viewData: OrderSelfViewData) {
        if !viewData.whose {
            let actionReady = UIAction { [weak self] _ in
                guard let self = self else { return }
                changeStatusButton.isEnabled = false
                viewModel.trigger(.proccesedTappedButtonReady)
            }
            let actionCompleted = UIAction { [weak self] _ in
                guard let self = self else { return }
                viewModel.trigger(.proccesedTappedButtoncompleted)
            }

            changeStatusButton.removeTarget(nil, action: nil, for: .allEvents)
            changeStatusButton.isEnabled = true

            switch viewData.status {
            case 0:
                changeStatusButton.addAction(actionReady, for: .touchUpInside)
                changeStatusButton.backgroundColor = .blue
                changeStatusButton.setTitle("Загаз готов", for: .normal)

            case 1:
                changeStatusButton.addAction(actionCompleted, for: .touchUpInside)
                changeStatusButton.backgroundColor = .blue
                changeStatusButton.setTitle("Заказ отдан", for: .normal)
            case 2:
                changeStatusButton.backgroundColor = .lightGray
                changeStatusButton.setTitle("Выполнено", for: .normal)
                changeStatusButton.isEnabled = false
            default:
                break
            }
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let section = 0
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems.filter { $0.section == section }
        for indexPath in visibleIndexPaths {
            if let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
                if collectionView.contentOffset.x <= layoutAttributes.center.x &&
                    layoutAttributes.center.x <= collectionView.contentOffset.x + collectionView.bounds.width {
                    segmentControlInput?.proccesedScrollItem(index: indexPath.item)
                }
            }
        }
    }
}
