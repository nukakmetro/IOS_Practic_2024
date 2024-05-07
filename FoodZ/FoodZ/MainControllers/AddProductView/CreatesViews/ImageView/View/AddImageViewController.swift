//
//  AddImageViewController.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import UIKit
import Combine

class AddImageViewController<ViewModel: AddImageViewModel>: UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, AddImageCellType >?
    private var items: [AddImageCellType]
    private var cancellables: Set<AnyCancellable> = []
    private let imagePicker = UIImagePickerController()

    private lazy var continueButton = UIButton()
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(
            ImageCell.self,
            forCellWithReuseIdentifier: ImageCell.reuseIdentifier
        )
        collectionView.register(
            AddImageCell.self,
            forCellWithReuseIdentifier: AddImageCell.reuseIdentifier
        )
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
        setupButton()
        makeConstraints()
        createDataSource()
        configureIO()
        viewModel.trigger(.onDidLoad)
        view.backgroundColor = .red
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: Private methods

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
        case .error:
            break
        }
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, AddImageCellType>(collectionView: collectionView) { [weak self] _, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .addImage:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.reuseIdentifier, for: indexPath) as? AddImageCell else {
                    fatalError("Unable to dequeue \(AddImageCell.self)")
                }
                return cell
            case .image(let image):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
                    fatalError("Unable to dequeue \(ImageCell.self)")
                }
                cell.configure(image: image.image, indexPathRow: indexPath.row)
                cell.delegate = self
                return cell
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AddImageCellType>()
        snapshot.appendSections([0])
        snapshot.appendItems(Array(items), toSection: 0)
        dataSource?.apply(snapshot)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createTableSection()
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        return layout
    }

    private func createTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(0.2)
        )

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .none
        return layoutSection
    }

    private func makeConstraints() {
        setupButton()
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
            make.bottom.equalToSuperview().inset(40)
        }
    }

    private func setupButton () {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            viewModel.trigger(.proccesedTappedSendProduct)
        }
        continueButton.addAction(action, for: .touchUpInside)
        continueButton.setTitle("Добавить продукт", for: .normal)
        continueButton.backgroundColor = .blue
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items.count - 1 == indexPath.row {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            viewModel.trigger(.proccesedAddImage(pickedImage))
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ImageCellDelegate

extension AddImageViewController: ImageCellDelegate {
    func proccesedTappedDelete(_ indexPathRow: Int) {

    }
}
