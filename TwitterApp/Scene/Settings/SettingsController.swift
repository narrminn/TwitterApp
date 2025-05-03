//
//  SettingController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 13.04.25.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    fileprivate func configureUI() {
//        navigationItem.title = "Notifications"
//        
//        navigationController?.navigationBar.tintColor = .twitterBlue
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SettingsCell.self)") as! SettingsCell
        
        return cell
    }
}
