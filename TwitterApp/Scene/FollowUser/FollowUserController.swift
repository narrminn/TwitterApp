//
//  LikedUserController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import UIKit
import Foundation

class FollowUserController: UIViewController {
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
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let filterBar = FollowFilterView()
    
    //MARK: - Properties
    
    private var viewModel: FollowUserViewModel
    
    var selectedFollowFilterOption: FollowFilterOption = .following
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
    
    init(userId: Int) {
        self.viewModel = FollowUserViewModel(userId: userId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureViewModel() {
    
        viewModel.getFollowingUserSuccess = {
            self.tableView.reloadData()
        }
        
        viewModel.getFollowersUserSuccess = {
            self.tableView.reloadData()
        }
        
        viewModel.errorHandling = { error in
            self.present(Alert.showAlert(title: "Error", message: error), animated: true)
        }
        
        Task { @MainActor in
            await viewModel.getFollowingUser()
            await viewModel.getFollowersUser()
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func configureUI() {
        
        navigationController?.navigationBar.tintColor = .twitterBlue
        
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        view.addSubview(filterBar)
        view.addSubview(underLine)
        view.addSubview(tableView)
        
        filterBar.delegate = self
        
        filterBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 50)
        
        underLine.anchor(top: filterBar.bottomAnchor, left: view.leftAnchor, width: view.frame.width / 2, height: 2)
        
        // tableView constraints
        tableView.anchor(top: underLine.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.bottomAnchor,
                         right: view.rightAnchor)
    }
}

extension FollowUserController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedFollowFilterOption == .following {
            return viewModel.followingUser.count
        }
        return viewModel.followersUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ImageNameTableCell.self)") as! ImageNameTableCell
        
        if selectedFollowFilterOption == .following {
            cell.configure(data: viewModel.followingUser[indexPath.row])
        } else {
            cell.configure(data: viewModel.followersUser[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
}

extension FollowUserController: FollowFilterViewDelegate {
    func filterView(_ view: FollowFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? SegmentFilterCell else { return }
        
        selectedFollowFilterOption = FollowFilterOption.allCases[indexPath.row]
        tableView.reloadData()
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underLine.frame.origin.x = xPosition
        }
    }
}
