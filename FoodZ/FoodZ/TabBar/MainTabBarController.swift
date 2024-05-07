//
//  MainTabBarController.swift
//  Foodp2p
//
//  Created by surexnx on 14.03.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let profileCoordinator: Coordinator
    private let homeCoordinator: Coordinator
    private let savedCoordinator: Coordinator
    private let addCoordinator: Coordinator
//    private let cartViewContoller: CartViewController

    init(authUser: UserExitProcessorDelegate) {
        let coordinatorFactory = CoordinatorFactory()
        homeCoordinator = coordinatorFactory.createHomeCoordinators(navigationController: UINavigationController())
        profileCoordinator = coordinatorFactory.createProfileCoordinator(authUser: authUser, navigationController: UINavigationController())
        savedCoordinator = coordinatorFactory.crateSavedCoordinator(navigationController: UINavigationController())
        addCoordinator = coordinatorFactory.createAddCoordinator(navigationController: UINavigationController())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNavigationController = homeCoordinator.navigationController
        let profileNavigationController = profileCoordinator.navigationController
        let savedNavigationController = savedCoordinator.navigationController
        let addNavigationController = addCoordinator.navigationController
        let cartNavigationController = UINavigationController(rootViewController: CartViewController())

        guard 
            let homeNavigationController = homeNavigationController,
            let profileNavigationController = profileNavigationController,
            let savedNavigationController = savedNavigationController,
            let addNavigationController = addNavigationController
        else { return }

        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")
        savedNavigationController.tabBarItem.image = UIImage(systemName: "heart")
        cartNavigationController.tabBarItem.image = UIImage(systemName: "cart")
        addNavigationController.tabBarItem.image = UIImage(systemName: "plus.app")
        profileNavigationController.tabBarItem.image = UIImage(systemName: "person")

        viewControllers = [
            homeNavigationController,
            savedNavigationController,
            addNavigationController,
            cartNavigationController,
            profileNavigationController
        ]
    }

}
