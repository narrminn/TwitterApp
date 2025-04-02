//
//  FeedViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

class OtherProfileViewModel {
    var manager = ProfileManager()
    var tweetManager = TweetManager()
    
    var profile: ProfileModelUser?
    var userId: Int
    
    var profileGetSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    var followProfileSuccess: (() -> Void)?
    
    var getTweetAllOwnSuccess: (() -> Void)?
    var getTweetAllRepliesSuccess: (() -> Void)?
    var getTweetAllLikedSuccess: (() -> Void)?
    var getTweetAllSavedSuccess: (() -> Void)?
    
    var tweetAllOwnResponse: TweetAllModel?
    var tweetAllRepliesResponse: TweetAllModel?
    var tweetAllLikedResponse: TweetAllModel?
    var tweetAllSavedResponse: TweetAllModel?
    
    var tweetAllOwnData = [TweetAll]()
    var tweetAllRepliesData = [TweetAll]()
    var tweetAllLikedData = [TweetAll]()
    var tweetAllSavedData = [TweetAll]()
    
    init(userId: Int) {
        self.userId = userId
        getOtherProfile()
    }
    
    func getOtherProfile() {
        manager.otherProfile(userId: userId){ response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.profile = response.data?.user
                
                self.getTweetAllOwn()
                self.getTweetAllReplies()
                self.getTweetAllLiked()
                self.getTweetAllSaved()
                
                self.profileGetSuccess?()
            }
        }
    }
    
    func getTweetAllOwn() -> Void {
        tweetManager.tweetAllOwn(page: (tweetAllOwnResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetAllOwnResponse = response
                self.tweetAllOwnData.append(contentsOf: response.data?.tweets ?? [])
                
                self.getTweetAllOwnSuccess?()
            }
        }
    }
    
    func getTweetAllReplies() -> Void {
        tweetManager.tweetAllReplies(page: (tweetAllRepliesResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetAllRepliesResponse = response
                self.tweetAllRepliesData.append(contentsOf: response.data?.tweets ?? [])
                
                self.getTweetAllRepliesSuccess?()
            }
        }
    }
    
    func getTweetAllLiked() -> Void {
        tweetManager.tweetAllLiked(page: (tweetAllLikedResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetAllLikedResponse = response
                self.tweetAllLikedData.append(contentsOf: response.data?.tweets ?? [])
                
                self.getTweetAllLikedSuccess?()
            }
        }
    }
    
    func getTweetAllSaved() -> Void {
        tweetManager.tweetAllSaved(page: (tweetAllSavedResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetAllSavedResponse = response
                self.tweetAllSavedData.append(contentsOf: response.data?.tweets ?? [])
                
                self.getTweetAllSavedSuccess?()
            }
        }
    }
    
    func resetAllOwn() {
        tweetAllOwnResponse = nil
        tweetAllOwnData.removeAll()
    }
    
    func paginationAllOwn(index: Int) {
        if tweetAllOwnData.count - 2 == index && (tweetAllOwnResponse?.meta?.page ?? 0 < (tweetAllOwnResponse?.meta?.totalPage ?? 0)) {
            getTweetAllOwn()
        }
    }
    
    func resetAllReplies() {
        tweetAllRepliesResponse = nil
        tweetAllRepliesData.removeAll()
    }
    
    func paginationAllReplies(index: Int) {
        if tweetAllRepliesData.count - 2 == index && (tweetAllRepliesResponse?.meta?.page ?? 0 < (tweetAllRepliesResponse?.meta?.totalPage ?? 0)) {
            getTweetAllReplies()
        }
    }
    
    func resetAllLiked() {
        tweetAllLikedResponse = nil
        tweetAllLikedData.removeAll()
    }
    
    func paginationAllLiked(index: Int) {
        if tweetAllLikedData.count - 2 == index && (tweetAllLikedResponse?.meta?.page ?? 0 < (tweetAllLikedResponse?.meta?.totalPage ?? 0)) {
            getTweetAllLiked()
        }
    }
    
    func resetAllSaved() {
        tweetAllSavedResponse = nil
        tweetAllSavedData.removeAll()
    }
    
    func paginationAllSaved(index: Int) {
        if tweetAllSavedData.count - 2 == index && (tweetAllSavedResponse?.meta?.page ?? 0 < (tweetAllSavedResponse?.meta?.totalPage ?? 0)) {
            getTweetAllSaved()
        }
    }
    
    func followProfile() {
        manager.followProfile(userId: userId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.followProfileSuccess?()
            }
        }
    }
}
