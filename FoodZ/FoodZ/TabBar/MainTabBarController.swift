//
//  MainTabBarController.swift
//  Foodp2p
//
//  Created by surexnx on 14.03.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let profileCoordinator: ProfileCoordinator
    private let homeCoordinator: HomeCoordinator
//    private let savedViewController: SavedViewController
//    private let cartViewContoller: CartViewController

    init(authUser: ProcessUserExitDelegate){
        homeCoordinator = CoordinatorFactory().createHomeCoordinators(navigationController: UINavigationController())
        homeCoordinator.start()
        profileCoordinator = CoordinatorFactory().createProfileCoordinator(navigationController: UINavigationController())
        profileCoordinator.authUser = authUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeViewController = homeCoordinator.navigationController
        let profileViewContoller = profileCoordinator.navigationController
        let savedViewController = UINavigationController(rootViewController: SavedViewController())
        let cartViewContoller = UINavigationController(rootViewController: CartViewController())

        guard let homeViewController = homeViewController, let profileViewContoller = profileViewContoller else { return }

        homeViewController.tabBarItem.image = UIImage(systemName: "house")
        savedViewController.tabBarItem.image = UIImage(systemName: "heart")
        cartViewContoller.tabBarItem.image = UIImage(systemName: "cart")
        profileViewContoller.tabBarItem.image = UIImage(systemName: "person")

        viewControllers = [homeViewController, savedViewController, cartViewContoller, profileViewContoller]
    }

}
