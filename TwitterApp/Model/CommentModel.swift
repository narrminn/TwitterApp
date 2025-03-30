//
//  CommentModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import Foundation

// MARK: - CommentModel
struct CommentModel: Codable {
    let message: String?
    let data: CommentModelData?
}

// MARK: - CommentModelData
struct CommentModelData: Codable {
    let comments: [Comment]?
}

// MARK: - Comment
struct Comment: Codable {
    let id: Int?
    let comment, createdAt: String
    let userID: Int?
    let name, username: String
    let profilePhotoPath: String?

    enum CodingKeys: String, CodingKey {
        case id, comment
        case createdAt = "created_at"
        case userID = "user_id"
        case name, username
        case profilePhotoPath = "profile_photo_path"
    }
}

