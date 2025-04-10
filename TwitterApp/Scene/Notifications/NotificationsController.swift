//
//  NotificationsController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class NotificationsController: UIViewController {
    //MARK: - UI Elements
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NotificationsCell.self, forCellReuseIdentifier: "\(NotificationsCell.self)")
        tv.backgroundColor = .systemBackground
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //MARK: - Properties
    var viewModel = NotificationsViewModel()
    var refreshController = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
    }
    
    @objc func pullToRefresh() {
        refreshAction()
    }
    
    
    // MARK: - Helpers
    
    func configureViewModel() {
        bindViewModel()
        
        Task { @MainActor in
            await viewModel.notifications()
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    func bindViewModel() {
        Task { @MainActor in
            viewModel.stateUpdated = { [weak self] state in
                switch state {
                case .notificationsSuccess:
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                case .loading:
                    break
                case .loaded:
                    break
                case .errorHandling(_):
                    self?.present(Alert.showAlert(title: "Error", message: "Error occurred while fetching data"), animated: true)
                    self?.tableView.refreshControl?.endRefreshing()
                case .idle:
                    break;
                }
            }
        }
    }
    
    func refreshAction() {
        viewModel.reset()
        
        tableView.reloadData()
        
        Task {@MainActor in
                await viewModel.notifications()
        }
    }
    
    fileprivate func configureUI() {
        navigationItem.title = "Notifications"
        
        navigationController?.navigationBar.tintColor = .twitterBlue
        
        configureConstraints()
    }
    
    fileprivate func configureConstraints() {
        view.addSubview(tableView)
        
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension NotificationsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notificationsAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(NotificationsCell.self)") as! NotificationsCell
        cell.configure(data: viewModel.notificationsAllData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let coordinator = ProfileCoordinator(navigationController: navigationController!, userId: viewModel.notificationsAllData[indexPath.row].id ?? 0)
//        
//        coordinator.start()
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        Task { @MainActor in
            await viewModel.pagination(index: indexPath.row)
        }
    }
}
