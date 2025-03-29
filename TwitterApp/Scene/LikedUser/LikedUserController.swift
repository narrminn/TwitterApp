//
//  LikedUserController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import UIKit

class LikedUserController: UIViewController {
    //MARK: - UI Elements
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(ImageNameTableCell.self, forCellReuseIdentifier: "\(ImageNameTableCell.self)")
        tv.backgroundColor = .systemBackground
//        tv.separatorStyle = .singleLine
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //MARK: - Properties
    
    private var viewModel: LikedUserViewModel
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    init(tweetId: Int) {
        self.viewModel = LikedUserViewModel(tweetId: tweetId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViewModel() {
    
        viewModel.getLikedUserSuccess = {
            self.tableView.reloadData()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
        }
        
        viewModel.getLikedUser()
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        navigationItem.title = "Liked Users"
        
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

extension LikedUserController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.likedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ImageNameTableCell.self)") as! ImageNameTableCell
        
        cell.configure(data: viewModel.likedUsers[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
}
