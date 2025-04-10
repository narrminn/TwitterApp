//
//  ExploreViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 06.04.25.
//

import Foundation

class ExploreViewModel {
    var manager = ProfileManager()
    
    var searchResponse: SearchProfileModel?
    var searchAllData: [SearchProfile] = []
    var keyword: String?
    
    enum ViewState {
        case loading
        case loaded
        case searchSuccess
        case errorHandling(String)
        case idle
    }
    
    var stateUpdated: ((ViewState) -> Void)?
    
    var state: ViewState = .idle {
        didSet {
            stateUpdated?(state)
        }
    }
    
    func search(keyword: String) async {
        do {
            state = .loading
            
            let response = try await manager.searchProfile(page: (searchResponse?.meta?.page ?? 0) + 1, keyword: keyword)
            Task { @MainActor in
                searchResponse = response
                searchAllData.append(contentsOf: response.data?.users ?? [])
                state = .searchSuccess
                
                state = .loaded
            }
        } catch {
            Task { @MainActor in
                state = .errorHandling(error.localizedDescription)
            }
        }
    }
    
    func reset() {
        searchAllData = []
        searchResponse = nil
    }
    
    func pagination(index: Int) async {
        if searchAllData.count - 2 == index && (searchResponse?.meta?.page ?? 0 < (searchResponse?.meta?.totalPage ?? 0)) {
            if let keyword = keyword {
                 await search(keyword: keyword)
            }
        }
    }
}
