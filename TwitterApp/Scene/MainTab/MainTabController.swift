//
//  MainTabController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class MainTabController: UITabBarController {
    //MARK: - UI Elements
    
    let createTweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func createTweetButtonTapped() {
        if let navController = selectedViewController as? UINavigationController {
            let coordinator = CreateTweetCoordinator(navigationController: navController, viewController: self.selectedViewController)
            coordinator.start()
        }
    }
    
    func setCreateTweetButton(hidden: Bool) {
        createTweetButton.isHidden = hidden
    }
    
    func configureUI() {
        view.addSubview(createTweetButton)
        createTweetButton.addTarget(self, action: #selector(createTweetButtonTapped), for: .touchUpInside)
        configureConstraints()
    }
    
    func configureConstraints() {
        createTweetButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor,
                                 paddingBottom: 64,
                                 paddingRight: 16,
                                 width: 56,
                                 height: 56)
        createTweetButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "bell"), rootViewController: notifications)
        
        let profile = ProfileController()
        let nav4 = templateNavigationController(image: UIImage(systemName: "person"), rootViewController: profile)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        
        return nav
    }
}
