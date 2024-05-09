//
//  AddImageBuilder.swift
//  FoodZ
//
//  Created by surexnx on 07.05.2024.
//

import Foundation
import UIKit

final class AddImageBuilder: Builder {

    // MARK: Private properties

    private let output: AddImageModuleOutput

    // MARK: Initialization

    init(output: AddImageModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = ProductRepository()
        var fileManager: ImageFileManager?
        if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            fileManager = ImageFileManager(documentsDirectory: directory)
        }
        let viewModel = AddImageViewModel(output: output, repository: repository, fileManager: fileManager)
        let controller = AddImageViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
}
