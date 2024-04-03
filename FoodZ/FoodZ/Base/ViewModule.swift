//
//  ViewModule.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Combine

protocol ViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Intent

    var state: State { get }

    func trigger(_ intent: Intent)
}

protocol UIKitViewModel: ViewModel {
    var stateDidChange: ObservableObjectPublisher { get }
}
