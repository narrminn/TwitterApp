//
//  RegisterCoordinator.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation
import UIKit

class TweetDetailCoordinator : Coordinator {
    var navigationController: UINavigationController
    var tweetId: Int
    
    init(navigationController: UINavigationController, tweetId: Int) {
        self.navigationController = navigationController
        self.tweetId = tweetId
    }
    
    func start() {
        let controller = TweetDetailController(tweetId: tweetId)
        
        self.navigationController.show(controller, sender: nil)
    }
}
