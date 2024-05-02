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
    private var dataSource: UICollectionViewDiffableDataSource<Int, OrdersViewCellType>?
    private var items: [OrdersViewCellType]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            OrderCell.self,
            forCellWithReuseIdentifier: OrderCell.reuseIdentifier
        )
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return collectionView
    }()

    // MARK: Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.items = []
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
            items = dispayData
            reloadData()
        case .error(let dispayData):
            items = dispayData
            reloadData()
        }
    }

    private func configure<T: SelfConfiguringOrderCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        return cell
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, OrdersViewCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            switch item {
            case .orderCell(let data):
                let cell = self?.configure(OrderCell.self, for: indexPath)
                cell?.configure(with: data)
                return cell
            }
        }
    }
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, OrdersViewCellType>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(items), toSection: 0)
        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createTableSection(fractionalHeight: 0.3, fractionalWidth: 0.9)
            default:
                return self.createTableSection(fractionalHeight: 0.3, fractionalWidth: 0.9)
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private func createTableSection(fractionalHeight: CGFloat, fractionalWidth: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fractionalWidth),
            heightDimension: .fractionalHeight(fractionalHeight)
        )
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
