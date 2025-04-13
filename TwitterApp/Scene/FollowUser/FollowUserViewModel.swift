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
    
    func getFollowingUser() async {
        do {
            let response = try await profileManager.followingUser(userId: userId)
            
            Task { @MainActor in
                followingUser = response.data?.users ?? []
                
                self.getFollowingUserSuccess?()
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    func getFollowersUser() async {
        do {
            let response = try await profileManager.followersUser(userId: userId)
            
            Task { @MainActor in
                followersUser = response.data?.users ?? []
                
                self.getFollowersUserSuccess?()
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
}

