//
//  AuthorizationViewController.swift
//  Foodp2p
//
//  Created by surexnx on 12.03.2024.
//

import UIKit
import Combine

class AuthorizationViewController: UIViewController {

    // MARK: Private properties

    private var viewModel: AuthorizationViewModel
    private var cancellebles: Set<AnyCancellable> = []

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nicknameTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        textField.placeholder = "nickname"
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .done
        textField.autocapitalizationType = .none
        textField.placeholder = "password"
        return textField
    }()

    private lazy var nicknameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var passwordLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorizationButton: UIButton = {
        let action = UIAction { [weak self] _ in
            guard let nickname = self?.nicknameTextField.text,
                  let password = self?.passwordTextField.text 
            else { return }
            let credentials: [String: String] = ["username": nickname, "password": password]
            self?.viewModel.trigger(.proccedButtonTapedAuthorizate(credentials))
            }
        var button = UIButton(primaryAction: action)
        button.setTitle("Авторизация", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var registrationButton: UIButton = {
        let action = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccedButtonTapedGoRegistrate)
            }
        var button = UIButton(primaryAction: action)
        button.setTitle("Регистрация", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: Initializator

    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        makeConstraints()
        view.backgroundColor = .white
        setupNameSubviews()
        configureBindings()
        viewModel.$validationNotify.sink { value in
            self.setErrorLabel(value)
        }.store(in: &cancellebles)
    }

    // MARK: Private methods

    private func addSubviews(_ views: UIView...) {
        views.forEach { view.addSubview($0) }
    }

    private func setupNameSubviews() {
        titleLabel.text = "Авторизация"
        nicknameLabel.text = "nickname"
        passwordLabel.text = "password"
    }
    private func configureBindings() {
        viewModel.$validationNotify.sink { [weak self] value in
            self?.statusLabel.text = value
        }.store(in: &cancellebles)
    }

    private func makeConstraints() {
        addSubviews(titleLabel,
                    nicknameTextField,
                    passwordTextField,
                    nicknameLabel,
                    passwordLabel,
                    authorizationButton,
                    statusLabel,
                    registrationButton)

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(50)
            maker.left.equalToSuperview().inset(50)
        }

        nicknameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel).inset(50)
            maker.centerX.equalToSuperview()
        }

        nicknameTextField.snp.makeConstraints { maker in
            maker.top.equalTo(nicknameLabel).inset(50)
            maker.centerX.equalToSuperview()
        }

        passwordLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nicknameTextField).inset(50)
            maker.centerX.equalToSuperview()
        }

        passwordTextField.snp.makeConstraints { maker in
            maker.top.equalTo(passwordLabel).inset(50)
            maker.centerX.equalToSuperview()
        }

        authorizationButton.snp.makeConstraints { maker in
            maker.top.equalTo(passwordTextField).inset(50)
            maker.centerX.equalToSuperview()
        }

        statusLabel.snp.makeConstraints {maker in
            maker.top.equalTo(authorizationButton).inset(50)
            maker.centerX.equalToSuperview()
        }

        registrationButton.snp.makeConstraints {maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.centerX.equalToSuperview()
        }
    }

    private func setErrorLabel(_ error: String) {
        statusLabel.text = error
    }
}

