//
//  HomeViewController.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import UIKit
import Combine
import SnapKit

class HomeViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: HomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var sections: [Section]
    private var cancellables: Set<AnyCancellable> = []

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            SearchHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchHeader.reuseIdentifier
        )
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.reuseIdentifier
        )
        collectionView.register(
            MediumTableCell.self,
            forCellWithReuseIdentifier: MediumTableCell.reuseIdentifier
        )
        return collectionView
    }()

    // MARK: Initialization

    init(viewModel: HomeViewModel) {
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

        viewModel.trigger(.onReload)
        createDataSource()
        bindings()
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: Private methods

    private func bindings() {
        viewModel.$sections.sink { [weak self] sections in
            self?.sections = sections
            self?.reloadData()
        }.store(in: &cancellables)
    }

    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with product: Product, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }

        cell.configure(with: product)
        return cell
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { collectionView, indexPath, product in
            switch self.sections[indexPath.section].type {
            case "mediumTable":
                return self.configure(MediumTableCell.self, with: product, for: indexPath)
            case "topHeader":
                return UICollectionViewCell()
            default:
                return self.configure(MediumTableCell.self, with: product, for: indexPath)
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in

            if indexPath.section == 0 {
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchHeader.reuseIdentifier, for: indexPath) as? SearchHeader else {
                    return SearchHeader()
                }
                return sectionHeader
            }
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                return SectionHeader()
            }
                guard let product = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
                guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: product) else { return nil }
                if section.title.isEmpty { return nil }

                sectionHeader.configure(title: section.title)
                return sectionHeader
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in

            let section = self.sections[sectionIndex]

            switch section.type {
            case "mediumTable":
                return self.createMediumTableSection(using: section)
            case "topHeader":
                return self.createFirstTableSection()
            default:
                return self.createMediumTableSection(using: section)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }

    private func createMediumTableSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .fractionalHeight(0.3))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }

    private func createFirstTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.65), heightDimension: .fractionalHeight(0.3))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        let layoutSectionHeader = createTopHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }

    private func createTopHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return layoutSectionHeader
    }

    private func makeConstraints() {
        view.backgroundColor = AppColor.primary.color
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            // make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
