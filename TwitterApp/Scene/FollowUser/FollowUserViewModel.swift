//
//  LikedUserViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import Foundation

class FollowUserViewModel {
    var tweetManager = TweetManager()
    
    var userId: Int
    
    var getLikedUserSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    init (userId: Int) {
        self.userId = userId
    }
}
