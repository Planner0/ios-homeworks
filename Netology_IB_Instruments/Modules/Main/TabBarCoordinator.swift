//
//  TabBarCoordinator.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 04.06.2022.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let firstModule = Factory(navigationController: UINavigationController(), state: .first)
    private let secondModule = Factory(navigationController: UINavigationController(), state: .second)
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        print("TabBar Coordinator Init")
        initTabBar()
    }
    
    func initTabBar() {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstModule.navigationController, secondModule.navigationController]
        navigationController.pushViewController(tabBarController, animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
}

