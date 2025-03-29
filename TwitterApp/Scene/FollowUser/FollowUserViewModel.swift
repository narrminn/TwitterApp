//
//  LikedUserViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import Foundation

class FollowUserViewModel {
    var profileManager = ProfileManager()
    
    var userId: Int
    var followingUser: [FollowUser] = []
    var followersUser: [FollowUser] = []
    
    var getFollowingUserSuccess: (() -> Void)?
    var getFollowersUserSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    init (userId: Int) {
        self.userId = userId
    }
    
    func getFollowingUser() {
        profileManager.followingUser(userId: userId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.followingUser = response.data?.users ?? []
                self.getFollowingUserSuccess?()
            }
        }
    }
    
    func getFollowersUser() {
        profileManager.followersUser(userId: userId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.followersUser = response.data?.users ?? []
                self.getFollowersUserSuccess?()
            }
        }
    }
}

