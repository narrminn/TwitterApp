//
//  RegisterCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation
import UIKit

class RegisterCoordinator : Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = RegisterController()
        
        self.navigationController.show(controller, sender: nil)
    }
}
