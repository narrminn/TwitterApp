//
//  LikedUserViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import Foundation

class LikedUserViewModel {
    var tweetManager = TweetManager()
    
    var tweetId: Int
    var likedUsers: [LikedUser] = []
    
    var getLikedUserSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    init (tweetId: Int) {
        self.tweetId = tweetId
    }
    
    func getLikedUser() {
        tweetManager.tweetLikedUser(tweetId: tweetId){ response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.likedUsers = response.data?.users ?? []
                self.getLikedUserSuccess?()
            }
        }
    }
}
