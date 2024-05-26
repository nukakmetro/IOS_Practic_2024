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
    private lazy var nicknameLabel = UILabel()
    private lazy var passwordLabel = UILabel()
    private lazy var confirmPasswordLabel = UILabel()
    private lazy var statusLabel = UILabel()

    private lazy var nicknameTextField = UITextField()
    private lazy var passwordTextField = UITextField()
    private lazy var confirmPassworTextField = UITextField()

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
            registrationButton,
            confirmPasswordLabel
        )

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.left.equalToSuperview().inset(50)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().inset(25)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(25)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(25)
        }
        confirmPassworTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        registrationButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.05)
            make.top.equalTo(confirmPassworTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        authorizationButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    private func setupLabels() {
        titleLabel.text = "Регистрация"
        titleLabel.font = .boldSystemFont(ofSize: 24)

        nicknameLabel.text = "Никнейм"
        nicknameLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.textColor = .darkGray

        passwordLabel.text = "Пароль"
        passwordLabel.font = .systemFont(ofSize: 13)
        passwordLabel.textColor = .darkGray

        confirmPasswordLabel.text = "Подтверждение пароля"
        confirmPasswordLabel.font = .systemFont(ofSize: 13)
        confirmPasswordLabel.textColor = .darkGray

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTextFields() {
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.returnKeyType = .next
        nicknameTextField.autocapitalizationType = .none
        nicknameTextField.placeholder = "Введите свой никнейм"
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.layer.borderColor = UIColor.black.cgColor
        nicknameTextField.layer.borderWidth = 1.0
        nicknameTextField.layer.cornerRadius = view.layer.frame.height / (6 / 0.05)

        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.returnKeyType = .next
        passwordTextField.placeholder = "Введите свой пароль"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = view.layer.frame.height / (6 / 0.05)

        confirmPassworTextField.isSecureTextEntry = true
        confirmPassworTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPassworTextField.returnKeyType = .next
        confirmPassworTextField.placeholder = "Подтвердите пароль"
        confirmPassworTextField.borderStyle = .roundedRect
        confirmPassworTextField.layer.borderColor = UIColor.black.cgColor
        confirmPassworTextField.layer.borderWidth = 1.0
        confirmPassworTextField.layer.cornerRadius = view.layer.frame.height / (6 / 0.05)
    }

    private func setupButtons() {
        let registrationButtonAction = UIAction { [weak self] _ in
            self?.proccedTapRegistrationButton()
            }
        registrationButton.addAction(registrationButtonAction, for: .touchUpInside)
        registrationButton.setTitle("Регистрация", for: .normal)
        registrationButton.setTitleColor(AppColor.secondary.color, for: .normal)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.backgroundColor = AppColor.primary.color
        registrationButton.layer.cornerRadius = view.layer.frame.height / (2 / 0.05)

        let authorizationButtonAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccedButtonTapedGoToAuth)
            }
        authorizationButton.addAction(authorizationButtonAction, for: .touchUpInside)
        authorizationButton.setTitle("Войти", for: .normal)
        authorizationButton.setTitleColor(AppColor.title.color, for: .normal)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        authorizationButton.setTitleColor(AppColor.primary.color, for: .normal)

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
