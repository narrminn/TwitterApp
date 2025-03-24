//
//  AppCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 24.03.25.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var window: UIWindow?
    
    init(window: UIWindow?, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        if KeychainManager.shared.retrieve(key: "userId") == nil {
            window?.rootViewController = UINavigationController(rootViewController: LoginController())
        } else {
            window?.rootViewController = MainTabController()
        }
        window?.makeKeyAndVisible()
    }
}
