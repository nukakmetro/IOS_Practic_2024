//
//  AuthorizationViewController.swift
//  Foodp2p
//
//  Created by surexnx on 12.03.2024.
//

import UIKit
import Combine

class AuthorizationViewController: UIViewController {

    private var contentView: AuthorizationView = {
        return AuthorizationView(frame: .zero)
    }()
    private var viewModel: AuthorizationViewModel

    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        contentView.setViewModel(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    var cancellebles: Set<AnyCancellable> = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$validationNotify.sink { value in
            self.contentView.setErrorLabel(value)
        }.store(in: &cancellebles)
    }

    override func loadView() {
        view = contentView
        navigationItem.hidesBackButton = true
    }
}

