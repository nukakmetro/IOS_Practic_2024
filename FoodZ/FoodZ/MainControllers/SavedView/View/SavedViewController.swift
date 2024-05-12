//
//  SavedViewController.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import UIKit
import Combine

final class SavedViewController<ViewModel: SavedViewModeling>: UIViewController {

    // MARK: Private properties

    private var items: [SavedCellType]
    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, SavedCellType>?
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
        reloadData()
        viewModel.trigger(.onDidLoad)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Сохраненные позиции"
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
        case .content(let dispayData):
            self.items = dispayData
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
        dataSource = UICollectionViewDiffableDataSource<Int, SavedCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .body(let data):
                let cell = configure(SingleCollectionViewCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            }
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SavedCellType>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)

        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in

            return self?.createBodyTableSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private func createBodyTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let indent = view.frame.width * 0.1 / 2
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: indent, bottom: 10, trailing: indent)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none
        return layoutSection
    }

    private func makeConstraints() {
        view.backgroundColor = AppColor.secondary.color
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
