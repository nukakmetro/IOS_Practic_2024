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
        authorizationButton.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.05)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(authorizationButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    private func setupLabels() {
        titleLabel.text = "Авторизация"
        titleLabel.font = .boldSystemFont(ofSize: 24)

        nicknameLabel.text = "Никнейм"
        nicknameLabel.font = .systemFont(ofSize: 13)
        nicknameLabel.textColor = .darkGray

        passwordLabel.text = "Пароль"
        passwordLabel.font = .systemFont(ofSize: 13)
        passwordLabel.textColor = .darkGray

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

    }

    private func setupButtons() {
        let registrationButtonAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccedButtonTapedGoRegistrate)
            }
        registrationButton.addAction(registrationButtonAction, for: .touchUpInside)
        registrationButton.setTitle("Регистрация", for: .normal)
        registrationButton.setTitleColor(AppColor.title.color, for: .normal)
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        registrationButton.setTitleColor(AppColor.primary.color, for: .normal)

        let authorizationButtonAction = UIAction { [weak self] _ in
            self?.proccedTapToAuthorizate()
            }
        authorizationButton.addAction(authorizationButtonAction, for: .touchUpInside)
        authorizationButton.setTitle("Войти", for: .normal)
        authorizationButton.setTitleColor(AppColor.secondary.color, for: .normal)
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        authorizationButton.backgroundColor = AppColor.primary.color
        authorizationButton.layer.cornerRadius = view.layer.frame.height / (2 / 0.05)
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

