//
//  MapViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import UIKit

final class MapViewBuilder: Builder {

    // MARK: Private properties

    private let output: MapModuleOutput

    // MARK: Initialization

    init(output: MapModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = PickUpPointRepository()
        let viewModel = MapViewModel(output: output, repository: remoteRepository)
        let controller = MapViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
}
