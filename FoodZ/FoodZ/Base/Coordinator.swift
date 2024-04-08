//
//  Coordinator.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {

    var navigationController: UINavigationController? { get set }
    func start()
}
