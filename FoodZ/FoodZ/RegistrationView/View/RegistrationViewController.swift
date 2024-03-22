//
//  RegistrationViewController.swift
//  Foodp2p
//
//  Created by surexnx on 06.03.2024.
//

import UIKit

class RegistrationViewController: UIViewController {

    private var contentView: RegistrationView = {
        return RegistrationView(frame: .zero)
    }()

    init(viewModel: RegistrationViewModel) {
        contentView.setViewModel(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
        navigationItem.hidesBackButton = true
    }
}
