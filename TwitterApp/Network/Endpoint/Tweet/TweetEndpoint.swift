//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum TweetEndpoint {
    case tweetStore
    case tweetAll
    case tweetLike(tweetId: Int)
    case tweetBookmark(tweetId: Int)
    case tweetLikedUser(tweetId: Int)
    case tweetDetail(tweetId: Int)
    case tweetComment(tweetId: Int)
    case tweetCommentStore(tweetId: Int)
    
    var path: String {
        switch self {
            case .tweetStore:
                return NetworkHelper.shared.configureURL(endpoint: "tweet/store")
            case .tweetAll:
                return NetworkHelper.shared.configureURL(endpoint: "tweet/all/for-you")
            case .tweetLike(let tweetId):
                return NetworkHelper.shared.configureURL(endpoint: "tweet/like/\(tweetId)")
            case .tweetBookmark(let tweetId):
                return NetworkHelper.shared.configureURL(endpoint: "tweet/save/\(tweetId)")
            case .tweetLikedUser(let tweetId):
                return NetworkHelper.shared.configureURL(endpoint: "tweet/like/\(tweetId)/user-list")
            case .tweetDetail(let tweetId):
                return NetworkHelper.shared.configureURL(endpoint: "tweet/show/\(tweetId)")
            case .tweetComment(tweetId: let tweetId):
                return NetworkHelper.shared.configureURL(endpoint: "tweet/comments/all/\(tweetId)")
            case.tweetCommentStore(let tweetId):
                return NetworkHelper.shared.configureURL(endpoint: "tweet/comments/save/\(tweetId)")
        }
    }
}
