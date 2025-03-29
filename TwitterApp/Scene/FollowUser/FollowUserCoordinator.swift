//
//  RegisterCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation
import UIKit

class FollowUserCoordinator : Coordinator {
    var navigationController: UINavigationController
    var userId: Int
    
    init(navigationController: UINavigationController, userId: Int) {
        self.navigationController = navigationController
        self.userId = userId
    }
    
    func start() {
        let controller = FollowUserController(userId: userId)
        
        self.navigationController.show(controller, sender: nil)
    }
}
