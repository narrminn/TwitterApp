//
//  OtherProfileCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 31.03.25.
//

import Foundation
import UIKit

class OtherProfileCoordinator : Coordinator {
    var navigationController: UINavigationController
    var userId: Int
    
    init(navigationController: UINavigationController, userId: Int) {
        self.navigationController = navigationController
        self.userId = userId
    }
    
    func start() {
        
        if (userId != Int(KeychainManager.shared.retrieve(key: "userId") ?? "0")) {
            let controller = OtherProfileController(userId: userId)
            
            self.navigationController.show(controller, sender: nil)
        }
    }
}
