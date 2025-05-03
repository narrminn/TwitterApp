//
//  SettingController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 13.04.25.
//

import UIKit
import SafariServices

class SettingsController: UIViewController {
    //MARK: - UI Elements
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(SettingsCell.self, forCellReuseIdentifier: "\(SettingsCell.self)")
        tv.backgroundColor = .systemBackground
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //MARK: - Properties
    let options = SettingsOption.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBar = self.tabBarController as? MainTabController {
            tabBar.setCreateTweetButton(hidden: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let tabBar = self.tabBarController as? MainTabController {
            tabBar.setCreateTweetButton(hidden: false)
        }
    }
    
    // Method for opening the Privacy Policy page in Safari
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://your-privacy-policy-url.com") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    // Method for handling the log out process
    private func logOut() {
        // Remove userId from Keychain
        _ = KeychainManager.shared.delete(key: "userId")
        _ = KeychainManager.shared.delete(key: "token")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            
            let coordinator = AppCoordinator(window: sceneDelegate.window, navigationController: self.navigationController ?? UINavigationController())
            coordinator.start()
        }
    }
    
    fileprivate func configureUI() {
        navigationItem.title = "Settings"
        
        navigationController?.navigationBar.tintColor = .twitterBlue
        
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension SettingsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SettingsCell.self)") as! SettingsCell
        
        let option = options[indexPath.row]
        cell.configure(with: option)
        
//        cell.selectionStyle = .none
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]

        switch option {
        case .privacyPolicy:
            openPrivacyPolicy()
        case .logOut:
            logOut()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
}
