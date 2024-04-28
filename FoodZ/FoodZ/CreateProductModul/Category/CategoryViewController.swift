//
//  CategoryViewController.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import UIKit
import SnapKit
import Combine

final class CategoryViewController: UIViewController {

    // MARK: Private properties

    private lazy var tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, String>?
    private let viewModel: CategoryViewModel
    private let items: [String]
    private var headerName: String

    // MARK: Initialization

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        items = []
        self.headerName = viewModel.headerName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeConsraints()
        setupTableView()
    }

    // MARK: Private methods

    private func setupTableView() {
        tableView.register(CreateProductTableViewCell.self, forCellReuseIdentifier: CreateProductTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView) { _, indexPath, item in
            let cell = self.tableView.dequeueReusableCell(
                withIdentifier: CreateProductTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? CreateProductTableViewCell
            guard let cell = cell else { return UITableViewCell() }
            switch indexPath.section {
            case 0:
                cell.configureForHeader(self.headerName)
                return cell
            case 1:
                cell.configureForCell(item)
                return cell
            default:
                break
            }
            return UITableViewCell()
        }
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems([], toSection: 0)
        snapshot.appendSections([1])
        snapshot.appendItems(items, toSection: 1)
        dataSource?.apply(snapshot)
    }

    private func makeConsraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
