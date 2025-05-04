//
//  FeedViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

class FeedViewModel {
    var manager: TweetManagerUseCase
    
    var tweetGetSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    var tweetAllResponse: TweetAllModel?
    var tweetAllData = [TweetAll]()
    
    init(manager: TweetManagerUseCase) {
        self.manager = manager
        
        getTweetAll()
    }
    
    func getTweetAll() -> Void {
        manager.tweetAll(page: (tweetAllResponse?.meta?.page ?? 0) + 1) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetAllResponse = response
                self.tweetAllData.append(contentsOf: response.data?.tweets ?? [])
                
                self.tweetGetSuccess?()
            }
        }
    }
    
    func reset() {
        tweetAllResponse = nil
        tweetAllData.removeAll()
    }
    
    func pagination(index: Int) {
        if tweetAllData.count - 2 == index && (tweetAllResponse?.meta?.page ?? 0 < (tweetAllResponse?.meta?.totalPage ?? 0)) {
            getTweetAll()
        }
    }
}
