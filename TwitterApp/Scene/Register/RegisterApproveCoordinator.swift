//
//  RegisterCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation
import UIKit

class RegisterApproveCoordinator : Coordinator {
    var navigationController: UINavigationController
    var userId: Int
    
    init(userId: Int, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.userId = userId
    }
    
    func start() {
        let controller = RegisterApproveController(userId: userId)
        
        self.navigationController.show(controller, sender: nil)
    }
}
