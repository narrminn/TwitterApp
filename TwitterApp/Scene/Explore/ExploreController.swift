//  ExploreController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class ExploreController: UIViewController {
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(ImageNameTableCell.self, forCellReuseIdentifier: "\(ImageNameTableCell.self)")
        tv.backgroundColor = .systemBackground
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Properties
    private var viewModel = ExploreViewModel()
    private let refreshController = UIRefreshControl()
    private var searchDebounceTimer: Timer?
    private let searchController = UISearchController(searchResultsController: nil)

    private var inSearchMode: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
        configureViewModel()
    }

    @objc private func pullToRefresh() {
        refreshAction()
    }

    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshController
    }

    private func configureSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Twitter"
        navigationItem.searchController = searchController
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .systemBlue
        definesPresentationContext = true
    }

    private func configureViewModel() {
        bindViewModel()
        Task { @MainActor in
            await viewModel.search(keyword: viewModel.keyword ?? "")
            tableView.refreshControl?.endRefreshing()
        }
    }

    private func bindViewModel() {
        viewModel.stateUpdated = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .searchSuccess:
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            case .loading:
                break
            case .loaded:
                break
            case .errorHandling(_):
                self.present(
                    Alert.showAlert(title: "Error", message: "Error occurred while fetching data"),
                    animated: true
                )
                self.tableView.refreshControl?.endRefreshing()
            case .idle:
                break
            }
        }
    }

    private func refreshAction() {
        viewModel.reset()
        Task { @MainActor in
            await viewModel.search(keyword: viewModel.keyword ?? "")
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension ExploreController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchAllData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ImageNameTableCell.self)",
            for: indexPath
        ) as! ImageNameTableCell
        cell.configure(data: viewModel.searchAllData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinator = ProfileCoordinator(
            navigationController: navigationController!,
            userId: viewModel.searchAllData[indexPath.row].id ?? 0
        )
        coordinator.start()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        Task { @MainActor in
            await viewModel.pagination(index: indexPath.row)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchDebounceTimer?.invalidate()

        if searchText.isEmpty {
            viewModel.reset()
            tableView.reloadData()
        } else {
            searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.reset()
                self.viewModel.keyword = searchText
                Task { @MainActor in
                    await self.viewModel.search(keyword: searchText)
                }
            }
        }
    }
}

// MARK: - UISearchControllerDelegate
extension ExploreController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.reset()
        tableView.reloadData()
    }
}
