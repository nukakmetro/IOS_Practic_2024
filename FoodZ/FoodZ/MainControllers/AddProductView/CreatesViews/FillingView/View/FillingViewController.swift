//
//  FillingViewController.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import UIKit
import Combine

class FillingViewController<ViewModel: FillingViewModeling>: UIViewController {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, FillingCellType>?
    private var items: [FillingCellType]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            FillingCell.self,
            forCellWithReuseIdentifier: FillingCell.reuseIdentifier
        )
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return collectionView
    }()

    private lazy var continueButton = UIButton()

    // MARK: Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.items = []
        viewModel.trigger(.onDidLoad)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        makeConstraints()
        createDataSource()
        configureIO()
        viewModel.trigger(.onLoad)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButton))
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Private methods

    @objc private func saveButton() {
        viewModel.trigger(.proccesedTappedSaveButton(collectDataFromCells()))
    }

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

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, FillingCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .oneLine(let data):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FillingCell.reuseIdentifier, for: indexPath) as? FillingCell else {
                    fatalError("Unable to dequeue \(FillingCell.self)")
                }
                cell.configure(with: data)
                return cell
            }
        }
    }
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FillingCellType>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self?.createTableSection(fractionalHeight: 0.1, fractionalWidth: 0.9)
            default:
                return self?.createTableSection(fractionalHeight: 0.3, fractionalWidth: 0.9)
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private func createTableSection(fractionalHeight: CGFloat, fractionalWidth: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

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
        view.addSubview(continueButton)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }

    private func collectDataFromCells() -> [FillingData] {
        var collectedData: [FillingData] = []
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? FillingCell {
                let data = cell.getData()
                collectedData.append(data)
            }
        }
        return collectedData
    }

    private func setupButton () {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.trigger(.proccesedTappedContinue(collectDataFromCells()))
        }
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addAction(action, for: .touchUpInside)
        continueButton.setTitle("Продолжить", for: .normal)
        continueButton.backgroundColor = .blue
    }
}
