//
//  ProfileCoordinator.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 04.06.2022.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    let user = User(fullName: "1", avatar: "elephant.jpg", status: "Люблю рыбий жир")
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    lazy var profileViewModel = ProfileViewModel(nav: self)
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    func start() {
        goToProfile()
    }
}
extension ProfileCoordinator: ProfileNavigation {
    func push() {
    }
    func pop() {
    }
    func goToProfile() {
        var profileVC = ProfileViewController(userServise: CurrentUserService(user: self.user), name: self.user.fullName)
#if DEBUG
        profileVC = ProfileViewController(userServise: TestUserService(), name: "name")
#endif
        profileVC.viewModel = ProfileViewModel(nav: self)
        profileVC.coordinator = self
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 0)
        navigationController.pushViewController(profileVC, animated: true)
    }
}
