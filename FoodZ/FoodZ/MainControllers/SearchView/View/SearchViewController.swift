//
//  SearchViewController.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import UIKit
import Combine

class SearchViewController<ViewModel: SearchViewModeling>: UIViewController {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<SearchSomeSection, SearchCellType>?
    private var sections: [SearchSomeSection]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            SearchHeaderCell.self,
            forCellWithReuseIdentifier: SearchHeaderCell.reuseIdentifier
        )
        collectionView.register(
            SingleCollectionViewCell.self,
            forCellWithReuseIdentifier: SingleCollectionViewCell.reuseIdentifier
        )
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return collectionView
    }()

    // MARK: Initializator

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.sections = []
        self.sections.append(SearchSomeSection.header([]))
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
        viewModel.trigger(.onDidlLoad)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: Private methods

    @objc private func didPullToRefresh() {
        DispatchQueue.global().async {
            self.viewModel.trigger(.onReload)
            print("start refresh")
            DispatchQueue.main.async {
                self.collectionView.refreshControl?.endRefreshing()
                print("end refresh")
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
        case .content(dispayData: let dispayData):
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
        dataSource = UICollectionViewDiffableDataSource<SearchSomeSection, SearchCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .bodyCell(let data):
                let cell = configure(SingleCollectionViewCell.self, for: indexPath)
                cell.configure(with: data)
                return cell
            case .header:
                let cell = configure(SearchHeaderCell.self, for: indexPath)
                cell.searchDelegate = self
                return cell
            }
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchSomeSection, SearchCellType>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .header(let data):
                snapshot.appendItems(data, toSection: section)
            case .body(let data):
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
            case .body:
                return createBodyTableSection()
            case .header:
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
        let indent = view.frame.width * 0.1 / 2
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: indent, bottom: 10, trailing: indent)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none
        return layoutSection
    }

    private func createHeaderTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

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

// MARK: SearchHeaderDelegate protocol

extension SearchViewController: SearchHeaderDelegate {

    func proccesedInputTextToSearch(inputText: String) {
        viewModel.trigger(.proccesedInputSearchText(inputText))
    }
    func proccesedButtonTapToBack() {
        viewModel.trigger(.onClose)
    }
}
