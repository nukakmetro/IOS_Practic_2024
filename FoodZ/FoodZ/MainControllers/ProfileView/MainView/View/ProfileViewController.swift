//
//  ProfileViewController.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import UIKit
import Combine
import SnapKit

final class ProfileViewController<ViewModel: ProfileMainModeling>: UIViewController, UICollectionViewDelegate {

    // MARK: Private properties

    private var items: [CellType]
    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, CellType>?
    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
            collectionView.register(
                ProfileMainBodyCell.self,
                forCellWithReuseIdentifier: ProfileMainBodyCell.reuseIdentifier
            )
            collectionView.register(
                ProfileMainHeaderCell.self,
                forCellWithReuseIdentifier: ProfileMainHeaderCell.reuseIdentifier
            )
        collectionView.delegate = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return collectionView
    }()

    // MARK: Initialization

    init( viewModel: ViewModel) {
        self.items = []
        self.viewModel = viewModel
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
            self.items = dispayData
            reloadData()
        case .error(let dispayData):
            self.items = dispayData
            reloadData()
        }
    }

    private func configure<T: ProfileSelfConfiguringCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        return cell
    }
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, CellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            switch item {
            case .header(let data):
                let cell = self?.configure(ProfileMainHeaderCell.self, for: indexPath)
                cell?.configure(with: data)
                return cell
            case .body(let data):
                let cell = self?.configure(ProfileMainBodyCell.self, for: indexPath)
                cell?.configure(with: data)
                return cell
            }
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellType>()
        snapshot.appendSections([0])
        snapshot.appendSections([1])
        snapshot.appendItems(Array(items.prefix(1)), toSection: 0)
        snapshot.appendItems(Array(items.suffix(from: 1)), toSection: 1)
        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self?.createTableSection(fractionalHeight: 0.3)
            case 1:
                return self?.createTableSection(fractionalHeight: 0.05)
            default:
                return self?.createTableSection(fractionalHeight: 0.3)
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private func createTableSection(fractionalHeight: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(fractionalHeight))
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

    // MARK: UICollectionViewDelegate protocol

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel.trigger(.processedTapItem(item: indexPath.row))
        }
    }
}
