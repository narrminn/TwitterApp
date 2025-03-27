//
//  TweetAllModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

// MARK: - TweetAllModel
struct TweetAllModel: Codable {
    let message: String?
    let data: TweetAllModelData?
    let meta: TweetAllMeta?
}

// MARK: - TweetAllModelData
struct TweetAllModelData: Codable {
    let tweets: [TweetAll]?
}

// MARK: - TweetAll
struct TweetAll: Codable, TweetCellProtocol {
    
    let id, createdBy: Int?
    let description, createdAt: String
    let likeCount, commentCount, retweetCount: Int
    let isLiked, isSavedBookmarked, canEdit: Bool
    let creator: Creator?
    let tweetFiles: [TweetFile]?
    
    var profileImage: String? { creator?.profilePhotoPath }
    
    var fullName: String { creator?.name ?? "" }
    
    var username: String { creator?.username ?? "" }
        
    var caption: String { description }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdBy = "created_by"
        case description
        case createdAt = "created_at"
        case likeCount = "like_count"
        case commentCount = "comment_count"
        case retweetCount = "retweet_count"
        case isLiked = "is_liked"
        case isSavedBookmarked = "is_saved_bookmarked"
        case canEdit = "can_edit"
        case creator
        case tweetFiles = "tweet_files"
    }
}

// MARK: - Creator
struct Creator: Codable {
    let id: Int?
    let name, username, profilePhotoPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, username
        case profilePhotoPath = "profile_photo_path"
    }
}

// MARK: - TweetFile
struct TweetFile: Codable {
    let id, tweetID: Int?
    let fileUUID, filePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case tweetID = "tweet_id"
        case fileUUID = "file_uuid"
        case filePath = "file_path"
    }
}

// MARK: - TweetAllMeta
struct TweetAllMeta: Codable {
    let total: Int?
    let page: Int?
    let limit, totalPage: Int?

    enum CodingKeys: String, CodingKey {
        case total, page, limit
        case totalPage = "total_page"
    }
}

