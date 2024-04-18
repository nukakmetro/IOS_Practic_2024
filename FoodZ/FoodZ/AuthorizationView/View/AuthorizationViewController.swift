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
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Private lazy properties

    private lazy var nicknameTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var titleLabel = UILabel()
    private lazy var nicknameLabel = UILabel()
    private lazy var passwordLabel = UILabel()
    private lazy var statusLabel = UILabel()
    private lazy var authorizationButton = UIButton()
    private lazy var registrationButton = UIButton()

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
        viewModel.trigger(.onDidLoad)
        setupDisplay()
        configureIO()
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
        case .content:
            break
        case .error(let error):
            statusLabel.text = error
        }
    }

    private func addSubviews(_ views: UIView...) {
        views.forEach { view.addSubview($0) }
    }

    private func setupDisplay() {
        makeConstraints()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        setupLabels()
        setupButtons()
        setupTextFields()
    }

    private func makeConstraints() {
        addSubviews(
            titleLabel,
            nicknameTextField,
            passwordTextField,
            nicknameLabel,
            passwordLabel,
            authorizationButton,
            statusLabel,
            registrationButton
        )
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

    private func setupLabels() {
        titleLabel.text = "Авторизация"
        nicknameLabel.text = "username"
        passwordLabel.text = "password"

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTextFields() {

        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.returnKeyType = .next
        nicknameTextField.autocapitalizationType = .none
        nicknameTextField.placeholder = "nickname"

        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.returnKeyType = .next
        passwordTextField.placeholder = "password"

    }

    private func setupButtons() {
        let registrationButtonAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccedButtonTapedGoRegistrate)
            }
        registrationButton.addAction(registrationButtonAction, for: .touchUpInside)
        registrationButton.setTitle("Регистрация", for: .normal)
        registrationButton.setTitleColor(AppColor.title.color, for: .normal)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false

        let authorizationButtonAction = UIAction { [weak self] _ in
            self?.proccedTapToAuthorizate()
            }
        authorizationButton.addAction(authorizationButtonAction, for: .touchUpInside)
        authorizationButton.setTitle("Войти", for: .normal)
        authorizationButton.setTitleColor(AppColor.title.color, for: .normal)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func proccedTapToAuthorizate() {
        guard
            let username = nicknameTextField.text,
            let password = passwordTextField.text
        else { return }
        let userRequest = UserRequest(username: username, password: password)
        self.viewModel.trigger(.proccedButtonTapedAuthorizate(userRequest))
    }
}

