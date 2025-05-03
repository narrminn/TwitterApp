//
//  CreateTweetCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 22.03.25.
//

import Foundation
import UIKit

class SettingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var viewController: UIViewController?

    init(navigationController: UINavigationController, viewController: UIViewController?) {
        self.navigationController = navigationController
        self.viewController = viewController
    }

    func start() {
        let controller = SettingsController()
        
        self.navigationController.show(controller, sender: nil)
    }
}

