//
//  OtherProfileCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 31.03.25.
//

import Foundation
import UIKit

class ProfileCoordinator : Coordinator {
    var navigationController: UINavigationController
    var userId: Int
    
    init(navigationController: UINavigationController, userId: Int) {
        self.navigationController = navigationController
        self.userId = userId
    }
    
    func start() {
        let controller = OtherProfileController(userId: userId)
        
        self.navigationController.show(controller, sender: nil)
    }
}
