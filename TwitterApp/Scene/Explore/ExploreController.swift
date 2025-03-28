//
//  ExploreController.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 17.03.25.
//

import UIKit

class ExploreController: UIViewController {
    //MARK: - UI Elements
    
    //MARK: - Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Twitter"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
    }
}
