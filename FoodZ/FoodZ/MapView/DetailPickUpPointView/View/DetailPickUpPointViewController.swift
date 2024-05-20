//
//  DetailPickUpPointViewController.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import UIKit
import Combine
import SnapKit

final class DetailPickUpPointViewController<ViewModel: DetailPickUpPointViewModeling>: UIViewController {

    // MARK: Private properties

    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    private lazy var nameLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var zipCodeLabel = UILabel()
    private lazy var button = UIButton()

    // MARK: Initialization

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.trigger(.onDidLoad)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDisplay()
        makeConstraint()
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
        case .content(let dispayData):
            setupDisplayData(displayData: dispayData)
        case .error:
            break
        }
    }

    private func makeConstraint() {
        view.addSubview(nameLabel)
        view.addSubview(addressLabel)
        view.addSubview(zipCodeLabel)
        view.addSubview(button)

        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(30)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).inset(30)
            make.leading.equalToSuperview().inset(30)
        }

        zipCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel).inset(30)
            make.leading.equalToSuperview().inset(30)
        }

        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }

    private func setupDisplay() {
        let action = UIAction { [weak self] _ in
            self?.viewModel.trigger(.proccesedTappedButtonSelect)
        }
        button.configuration = UIButton.Configuration.filled()
        button.layer.cornerRadius = 10
        button.setTitle("Заберу отсюда", for: .normal)
        button.addAction(action, for: .touchUpInside)

        nameLabel.font = .systemFont(ofSize: 16)
        addressLabel.font = .systemFont(ofSize: 18)
        zipCodeLabel.font = .systemFont(ofSize: 16)
    }

    private func setupDisplayData(displayData: DetailPickUpPointViewData) {
        nameLabel.text = displayData.pickUpPointName
        addressLabel.text = displayData.address
        zipCodeLabel.text = displayData.zipCode
    }

}
