//
//  AppCoordinator.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 04.06.2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        //print("AppCoordinatorStart")
        goToAuth()
    }
    
    func goToHome() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        children.removeAll()
        tabBarCoordinator.parentCoordinator = self
        tabBarCoordinator.start()
    }
    func goToAuth() {
        let authCoordinator = AuthCoordinator.init(navigationController: navigationController)
        children.removeAll()
        
        authCoordinator.parentCoordinator = self
        children.append(authCoordinator)
        
        authCoordinator.start()
    }
    deinit {
        print("AppCoordinator Deinit")
    }
}
