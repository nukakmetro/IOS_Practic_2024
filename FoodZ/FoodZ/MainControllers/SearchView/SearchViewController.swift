//
//  SearchViewController.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: Private properties

    private let viewModel: SearchViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Int,Product>?

//    private lazy var tableView: UITableView = {
//        var collectionView = UITableView(r)
//        return collectionView
//    }()

    // MARK: Initializator

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
