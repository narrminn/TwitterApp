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
    var email: String
    
    init(userId: Int, email: String, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.userId = userId
        self.email = email
    }
    
    func start() {
        let controller = RegisterApproveController(userId: userId, email: email)
        
        self.navigationController.show(controller, sender: nil)
    }
}
