//
//  FeedViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

class ProfileViewModel {
    var manager = ProfileManager()
    var tweetManager = TweetManager()
    
    var profile: ProfileModelUser?
    
    var profileGetSuccess: (() -> Void)?
    
    var errorHandling: ((String) -> Void)?
    
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
    
//    init() async {
//        await getMyProfile()
//    }
    
    func getMyProfile() async {
        do {
            let response = try await manager.myProfile()
            Task { @MainActor in
                profile = response.data?.user
                                
                await getTweetAllOwn()
                await getTweetAllReplies()
                await getTweetAllLiked()
                await getTweetAllSaved()
                
                profileGetSuccess?()
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    func getTweetAllOwn() async {
        do {
            let response = try await tweetManager.tweetAllOwn(page: (tweetAllOwnResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0)
            Task { @MainActor in
                tweetAllOwnResponse = response
                tweetAllOwnData.append(contentsOf: response?.data?.tweets ?? [])
                getTweetAllOwnSuccess?()
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    func getTweetAllReplies() async {
        do {
            let response = try await tweetManager.tweetAllReplies(page: (tweetAllRepliesResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0)
            Task { @MainActor in
                tweetAllRepliesResponse = response
                tweetAllRepliesData.append(contentsOf: response?.data?.tweets ?? [])
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    func getTweetAllLiked() async {
        do {
            let response = try await tweetManager.tweetAllLiked(page: (tweetAllLikedResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0)
            Task { @MainActor in
                tweetAllLikedResponse = response
                tweetAllLikedData.append(contentsOf: response?.data?.tweets ?? [])
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    func getTweetAllSaved() async {
        do {
            let response = try await tweetManager.tweetAllSaved(page: (tweetAllSavedResponse?.meta?.page ?? 0) + 1, userId: profile?.id ?? 0)
            Task { @MainActor in
                tweetAllSavedResponse = response
                tweetAllSavedData.append(contentsOf: response?.data?.tweets ?? [])
            }
        } catch {
            Task { @MainActor in
                errorHandling?(error.localizedDescription)
            }
        }
    }
    
    func resetAllOwn() {
        tweetAllOwnResponse = nil
        tweetAllOwnData = []
    }
    
    func paginationAllOwn(index: Int) async {
        if tweetAllOwnData.count - 2 == index && (tweetAllOwnResponse?.meta?.page ?? 0 < (tweetAllOwnResponse?.meta?.totalPage ?? 0)) {
            await getTweetAllOwn()
        }
    }
    
    func resetAllReplies() {
        tweetAllRepliesResponse = nil
        tweetAllRepliesData = []
    }
    
    func paginationAllReplies(index: Int) async {
        if tweetAllRepliesData.count - 2 == index && (tweetAllRepliesResponse?.meta?.page ?? 0 < (tweetAllRepliesResponse?.meta?.totalPage ?? 0)) {
            await getTweetAllReplies()
        }
    }
    
    func resetAllLiked() {
        tweetAllLikedResponse = nil
        tweetAllLikedData = []
    }
    
    func paginationAllLiked(index: Int) async {
        if tweetAllLikedData.count - 2 == index && (tweetAllLikedResponse?.meta?.page ?? 0 < (tweetAllLikedResponse?.meta?.totalPage ?? 0)) {
            await getTweetAllLiked()
        }
    }
    
    func resetAllSaved() {
        tweetAllSavedResponse = nil
        tweetAllSavedData = []
    }
    
    func paginationAllSaved(index: Int) async {
        if tweetAllSavedData.count - 2 == index && (tweetAllSavedResponse?.meta?.page ?? 0 < (tweetAllSavedResponse?.meta?.totalPage ?? 0)) {
            await getTweetAllSaved()
        }
    }
}
