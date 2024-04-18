//
//  RegistrationViewController.swift
//  Foodp2p
//
//  Created by surexnx on 06.03.2024.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: RegistrationViewModel
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Private lazy properties

    private lazy var titleLabel = UILabel()
    private lazy var nicknameTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var confirmPassworTextField = UITextField()
    private lazy var nicknameLabel = UILabel()
    private lazy var passwordLabel = UILabel()
    private lazy var statusLabel = UILabel()
    private lazy var registrationButton = UIButton()
    private lazy var authorizationButton = UIButton()

    // MARK: Initializator

    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

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

    private func setupDisplay() {
        makeConstraints()
        navigationItem.hidesBackButton = true
        view.backgroundColor = AppColor.secondary.color
        setupLabels()
        setupButtons()
        setupTextFields()
    }

    private func addSubviews(_ views: UIView...) {
        views.forEach { view.addSubview($0) }
    }

    private func makeConstraints() {
        addSubviews(
            titleLabel,
            nicknameTextField,
            passwordTextField,
            confirmPassworTextField,
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
        confirmPassworTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField).inset(50)
            make.centerX.equalToSuperview()
        }
        registrationButton.snp.makeConstraints { maker in
            maker.top.equalTo(confirmPassworTextField).inset(50)
            maker.centerX.equalToSuperview()
        }
        statusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(registrationButton).inset(50)
            maker.centerX.equalToSuperview()
        }
        authorizationButton.snp.makeConstraints { maker in
            maker.top.equalTo(statusLabel).inset(50)
            maker.centerX.equalToSuperview()
        }
    }

    private func setupLabels() {
        titleLabel.text = "Регистрация"
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
        passwordTextField.autocapitalizationType = .none
        passwordTextField.placeholder = "password"

        confirmPassworTextField.isSecureTextEntry = true
        confirmPassworTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPassworTextField.returnKeyType = .done
        confirmPassworTextField.autocapitalizationType = .none
        confirmPassworTextField.placeholder = "confirm password"
    }

    private func setupButtons() {
        let registrationButtonAction = UIAction { [weak self] _ in
            self?.proccedTapRegistrationButton()
            }
        registrationButton.addAction(registrationButtonAction, for: .touchUpInside)
        registrationButton.setTitle("Регистрация", for: .normal)
        registrationButton.setTitleColor(AppColor.title.color, for: .normal)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false

        let authorizationButtonAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccedButtonTapedGoToAuth)
            }
        authorizationButton.addAction(authorizationButtonAction, for: .touchUpInside)
        authorizationButton.setTitle("Есть аккаунт", for: .normal)
        authorizationButton.setTitleColor(AppColor.title.color, for: .normal)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func proccedTapRegistrationButton() {
        guard
            let username = nicknameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPassworTextField.text
        else { return }

        let userRegistrationRequst = UserRegistrationRequest(
            username: username,
            password: password,
            confirmPassword: confirmPassword
            )
        viewModel.trigger(.proccedButtonTapedRegistrate(userRegistrationRequst))
    }
}
