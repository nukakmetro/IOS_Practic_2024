//
//  AddImageViewModel.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation
import Combine
import UIKit

enum AddImageCellType: Hashable {
    case addImage
    case image(ImageCelltype)
}

struct ImageCelltype: Hashable {
    let id: UUID
    let image: UIImage
}

protocol AddImageViewModeling: UIKitViewModel where State == AddImageState, Intent == AddImageIntent {}

final class AddImageViewModel: AddImageViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: AddImageModuleOutput?
    private var repository: AddProductProtocol
    private let dataMapper: FillingDataMapper
    private var items: [AddImageCellType]
    private var selfProduct: ProductEntity?
    private let fileManager: ImageFileManager?

    // MARK: Internal properties

    @Published var state: AddImageState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: AddImageModuleOutput, repository: AddProductProtocol, fileManager: ImageFileManager?) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = FillingDataMapper()
        self.items = [.addImage]
        self.fileManager = fileManager
    }

    // MARK: Internal methods

    func trigger(_ intent: AddImageIntent) {
        switch intent {
        case .onDidLoad:
            output?.addImageModuleDidLoad(input: self)

        case .onClose:
            guard let product = selfProduct else { return }
            output?.proccesedCloseView(product: product)

        case .onReload:
            break

        case .proccesedTappedSendProduct:
            sendProduct()

        case .proccesedAddImage(let image):
            addImage(image: image)

        case .proccesedTappedSave:
            guard let product = selfProduct else { return }
            output?.proccesedTappedSaveButton(product: product)

        case .proccesedTappedDeleteImage(let id):
            deleteImage(id: id)
        }
    }

    // MARK: Private methods

    private func addImage(image: UIImage) {
        guard
            let fileManager = fileManager,
            let imageData = image.pngData() else { return }
        let id = UUID()
        items.insert(.image(ImageCelltype(id: id, image: image)), at: 0)
        fileManager.writeImage(id: id, image: imageData)
        state = .content(items)
    }

    private func saveProduct() {
        guard
            let product = selfProduct,
            let managedObjectContext = product.managedObjectContext
        else { 
            return
        }
        selfProduct?.images = []
        for item in items {
            if case .image(let imageCelltype) = item {
                let productImage = ProductImage(context: managedObjectContext)
                productImage.id = imageCelltype.id
                selfProduct?.images.insert(productImage)
            }
        }
        output?.proccesedTappedSaveButton(product: product)
    }

    private func deleteImage(id: UUID) {
        guard let fileManager = fileManager else { return }

        if let image = selfProduct?.images.first(where: { $0.id == id }) {
            selfProduct?.images.remove(image)
        }
        fileManager.removeImage(id: id)
        items = items.filter { element in
            if case .image(let imageCellType) = element {
                return imageCellType.id != id
            }
            return true
        }
        state = .content(items)
    }

    private func sendProduct() {
        var sendImages: [Data] = []
        items.forEach { celltype in
            switch celltype {
            case .addImage:
                break
            case .image(let image):
                guard let data = image.image.jpegData(compressionQuality: 0.8) else { return }
                sendImages.append(data)
            }
        }
        guard let selfProduct = selfProduct else { return }
        repository.sendProduct(product: selfProduct.mapToRequest(), images: sendImages) { [weak self] result in
            switch result {
            case .success(_):
                self?.trigger(.onClose)
            case .failure(_):
                break
            }
        }
    }
}

// MARK: - AddImageModuleInput

extension AddImageViewModel: AddImageModuleInput {
    func addImageModuleGiveAwayProduct(product: ProductEntity) {
        selfProduct = product
        product.images.forEach { [weak self] image in
            guard let self = self else { return }
            guard
                let imageData = fileManager?.fetchImage(id: image.id),
                let fetchImage = UIImage(data: imageData)
            else {
                return
            }
            items.insert(.image(ImageCelltype(id: image.id, image: fetchImage)), at: 0)
        }
        state = .content(items)
    }
}
