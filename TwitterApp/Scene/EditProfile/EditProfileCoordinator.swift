//
//  CreateTweetCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 22.03.25.
//

import Foundation
import UIKit

class EditProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var viewController: UIViewController?

    init(navigationController: UINavigationController, viewController: UIViewController?) {
        self.navigationController = navigationController
        self.viewController = viewController
    }

    func start() {
        let controller = EditProfileController()
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        viewController?.present(nav, animated: true)
    }
}

