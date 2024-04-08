//
//  MainTabBarController.swift
//  Foodp2p
//
//  Created by surexnx on 14.03.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // потом координаторы добавлю
        let homeCoordinator = CoordinatorFactory().createHomeCoordinators(navigationController: UINavigationController())
        homeCoordinator.start()
        let homeViewController = homeCoordinator.navigationController

        let savedViewController = UINavigationController(rootViewController: SavedViewController())
        let cartViewContoller = UINavigationController(rootViewController: CartViewController())
        let profileViewContoller = UINavigationController(rootViewController: ProfileViewController())

        homeViewController.tabBarItem.image = UIImage(systemName: "house")
        savedViewController.tabBarItem.image = UIImage(systemName: "heart")
        cartViewContoller.tabBarItem.image = UIImage(systemName: "cart")
        profileViewContoller.tabBarItem.image = UIImage(systemName: "person")
        viewControllers = [homeViewController, savedViewController, cartViewContoller, profileViewContoller]
    }

}
