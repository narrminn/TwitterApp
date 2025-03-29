//
//  FollowUserModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import Foundation

// MARK: - FollowUserModel
struct FollowUserModel: Codable {
    let message: String?
    let data: FollowUserData?
}

// MARK: - FollowUserData
struct FollowUserData: Codable {
    let users: [FollowUser]?
}

// MARK: - FollowUser
struct FollowUser: Codable, ImageNameTableProtocol {
    
    let id: Int?
    let name, username : String
    let profilePhotoPath: String?
    
    var profileImage: String? { profilePhotoPath }

    enum CodingKeys: String, CodingKey {
        case id, name, username
        case profilePhotoPath = "profile_photo_path"
    }
}

