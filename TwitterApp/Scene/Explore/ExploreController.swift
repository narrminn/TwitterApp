//
//  ExploreController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class ExploreController: UIViewController, UISearchControllerDelegate {
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
    
    var viewModel = ExploreViewModel()
    var refreshController = UIRefreshControl()

    // Controller daxilində əlavə et
    private var searchDebounceTimer: Timer?
    private var lastSearchText: String = ""
    
    private let searchController = UISearchController(searchResultsController: nil)
    
//    private var inSearchMode: Bool {
//        return searchController.isActive && !searchController.searchBar.text!.isEmpty
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
        configureViewModel()
    }
    
    @objc func pullToRefresh() {
        refreshAction()
    }
    
    // MARK: - Helpers
    
    func configureViewModel() {
        bindViewModel()
        
        Task { @MainActor in
            await viewModel.search(keyword: viewModel.keyword ?? "")
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    func bindViewModel() {
        Task { @MainActor in
            viewModel.stateUpdated = { [weak self] state in
                switch state {
                case .searchSuccess:
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
    
    func configureUI() {
        view.backgroundColor = .white
        configureConstraints()
    }
    
    func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Twitter"
        navigationItem.searchController = searchController
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .systemBlue
        definesPresentationContext = false
    }
    
    fileprivate func configureConstraints() {
        view.addSubview(tableView)
        
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        // tableView constraints
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor)
    }
    
    func refreshAction() {
        viewModel.reset()

        Task { @MainActor in
            await viewModel.search(keyword: viewModel.keyword ?? "")
        }
    }
}

extension ExploreController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ImageNameTableCell.self)") as! ImageNameTableCell
        cell.configure(data: viewModel.searchAllData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = ProfileCoordinator(navigationController: navigationController!,
                                             userId: viewModel.searchAllData[indexPath.row].id ?? 0)        
        coordinator.start()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        Task { @MainActor in
            await viewModel.pagination(index: indexPath.row)
        }
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }

        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.viewModel.reset()
            self?.viewModel.keyword = searchText

            Task { @MainActor in
                await self?.viewModel.search(keyword: searchText)
            }
        }
    }
}
