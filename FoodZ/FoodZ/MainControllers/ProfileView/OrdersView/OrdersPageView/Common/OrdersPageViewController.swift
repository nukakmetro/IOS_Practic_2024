//
//  OrdersPageViewController.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import UIKit
import Combine
import SnapKit

final class OrdersPageViewController<ViewModel: OrdersPageViewModeling>: UIViewController {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<OrderSectionType, OrderCellType>?
    private var sections: [OrderSectionType]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            OrderBodyCell.self,
            forCellWithReuseIdentifier: OrderBodyCell.reuseIdentifier
        )
        collectionView.register(
            OrderBodyHeaderCell.self,
            forCellWithReuseIdentifier: OrderBodyHeaderCell.reuseIdentifier
        )
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
        viewModel.trigger(.onDidLoad)
        view.backgroundColor = .red
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
        case .content(let dispayData):
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

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<OrderSectionType, OrderCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .bodyCell(let data):
                var cell = configure(OrderBodyCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            case .bodyHeaderCell(let data):
                var cell = configure(OrderBodyHeaderCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            }
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<OrderSectionType, OrderCellType>()
        snapshot.appendSections(sections)
        for section in sections {
            switch section {
            case .bodySection(_, let data):
                snapshot.appendItems(data, toSection: section)
            case .bodyHeaderSection(_, let data):
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

    private func makeConstraints() {
        view.backgroundColor = AppColor.primary.color
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
}
