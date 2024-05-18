//
//  SelfProductViewController.swift
//  FoodZ
//
//  Created by surexnx on 13.05.2024.
//

import UIKit
import Combine

final class SelfProductViewController<ViewModel: SelfProductViewModeling>: UIViewController, UICollectionViewDelegateFlowLayout {

    // MARK: Private properties

    private var sections: [SelfProductSectionType]
    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<SelfProductSectionType, SelfProductCellType>?
    private var cancellables: Set<AnyCancellable> = []
    weak var segmentControlInput: SelfProductImageGropeFooterInput?
    private lazy var addCartButton = UIButton()
    private var like: Bool?

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white

        collectionView.register(
            SelfProductImageCell.self,
            forCellWithReuseIdentifier: SelfProductImageCell.reuseIdentifier
        )
        collectionView.register(
            SelfProductInformationCell.self,
            forCellWithReuseIdentifier: SelfProductInformationCell.reuseIdentifier
        )
        collectionView.register(
            SelfProductImageGropeFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SelfProductImageGropeFooter.reuseIdentifier
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "suit.heart"), style: .plain, target: self, action: #selector(proccesedTappedLikeBarItemButton))
        navigationController?.navigationBar.barTintColor = AppColor.secondary.color
    }

    // MARK: Private methods

    @objc private func proccesedTappedLikeBarItemButton() {
        viewModel.trigger(.proccesedTappedButtonLike)
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
        dataSource = UICollectionViewDiffableDataSource<SelfProductSectionType, SelfProductCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .imagesCell(let id):
                let cell = configure(SelfProductImageCell.self, for: indexPath)
                cell.configure(imageId: id)
                return cell
            case .informationCell(let data):
                let cell = configure(SelfProductInformationCell.self, for: indexPath)
                cell.configure(cell: data)
                return cell
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SelfProductImageGropeFooter.reuseIdentifier, for: indexPath) as? SelfProductImageGropeFooter else {
                return nil
            }

            if case .imagesSection(let images) = sections[indexPath.section] {
                sectionFooter.configure(indexPath: indexPath)
            }
            sectionFooter.delegate = self
            return sectionFooter
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SelfProductSectionType, SelfProductCellType>()
        snapshot.appendSections(sections)
        for section in sections {
            switch section {
            case .imagesSection(let items):
                snapshot.appendItems(items, toSection: section)
            case .informationSection(let item):
                snapshot.appendItems([item], toSection: section)
            }
        }
        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in

            guard let self = self else { return self?.createImageSection() }
            let section = sections[sectionIndex]
            
            switch section {
            case .imagesSection:
                return createImageSection()
            case .informationSection:
                return createInformationSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }

    private func createImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        return layoutSection
    }

    private func createInformationSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

        return layoutSection
    }

    func createSectionFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }

    private func makeConstraints() {
        view.backgroundColor = AppColor.secondary.color
        view.addSubview(collectionView)
        view.addSubview(addCartButton)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }

        addCartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }

    private func setupDisplayView(viewData: SelfProductContentData) {
        let actionMyProduct = UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.trigger(.proccesedTappedButtonAddToCart)
        }
        let actionInCart = UIAction { [weak self] _ in
            guard let self = self else { return }
        }
        switch viewData.cartButton {
        case 0:
            addCartButton.backgroundColor = .lightGray
            addCartButton.setTitle("Ваш продукт", for: .normal)
        case 1:
            addCartButton.addAction(actionMyProduct, for: .touchUpInside)
            addCartButton.backgroundColor = .blue
            addCartButton.setTitle("Добавить в корзину", for: .normal)
        case 2:
            addCartButton.removeAction(actionMyProduct, for: .touchUpInside)
            addCartButton.addAction(actionInCart, for: .touchUpInside)
            addCartButton.backgroundColor = .blue
            addCartButton.setTitle("В корзинe", for: .normal)
        default:
            break
        }

        addCartButton.translatesAutoresizingMaskIntoConstraints = false
        if viewData.likeButton {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "suit.heart.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "suit.heart")
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

// MARK: - SelfProductImageGropeFooterOutput

extension SelfProductViewController: SelfProductImageGropeFooterOutput {
    func didLoadFooter(input: SelfProductImageGropeFooterInput) {
        segmentControlInput = input
    }

    func proccesedTappedSection(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}
