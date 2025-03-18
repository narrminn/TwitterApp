//
//  MainTabController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    func configureViewControllers() {
        
        let feed = FeedController()
        feed.tabBarItem.image = UIImage(systemName: "house")
        
        let explore = ExploreController()
        explore.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        let notifications = NotificationsController()
        notifications.tabBarItem.image = UIImage(systemName: "bell")
        
        let conversation = ConversationController()
        conversation.tabBarItem.image = UIImage(systemName: "bubble.left")
        
        let profile = ProfileController()
        profile.tabBarItem.image = UIImage(systemName: "person")
        
        viewControllers = [feed, explore, notifications, conversation, profile]
    }
}
