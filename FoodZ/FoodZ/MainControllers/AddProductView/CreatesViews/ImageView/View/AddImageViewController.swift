//
//  AddImageViewController.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import UIKit
import Combine

final class AddImageViewController<ViewModel: AddImageViewModel>: UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int, AddImageCellType >?
    private var items: [AddImageCellType]
    private var cancellables: Set<AnyCancellable> = []
    private let imagePicker: UIImagePickerController

    private lazy var continueButton = UIButton()
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.backgroundColor = AppColor.secondary.color
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
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
        imagePicker = UIImagePickerController()
        viewModel.trigger(.onDidLoad)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupImagePicker()
        makeConstraints()
        createDataSource()
        configureIO()
        viewModel.trigger(.onLoad)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", image: nil, target: self, action: #selector(saveButton))
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Private methods

    @objc private func saveButton() {
        viewModel.trigger(.proccesedTappedSaveButton)
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
                cell.configure(image: image.image, id: image.id)
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
            widthDimension: .fractionalWidth(0.33),
            heightDimension: .fractionalHeight(1)
        )

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let layoutGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.1)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

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
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
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

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    private func didTapAddCell() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            imagePicker.sourceType = .photoLibrary
            present(self.imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            imagePicker.sourceType = .camera
            present(self.imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items.count - 1 == indexPath.row {
            didTapAddCell()
        }
    }

    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            viewModel.trigger(.proccesedAddImage(pickedImage))
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ImageCellDelegate

extension AddImageViewController: ImageCellDelegate {
    func proccesedTappedDelete(_ id: UUID) {
        viewModel.trigger(.proccesedTappedDeleteImage(id: id))
    }
}
