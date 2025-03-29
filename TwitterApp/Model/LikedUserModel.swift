//
//  LikedUserModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 29.03.25.
//

import Foundation

// MARK: - LikedUserModel
struct LikedUserModel: Codable {
    let message: String?
    let data: LikedUserData?
}

// MARK: - LikedUserData
struct LikedUserData: Codable {
    let users: [LikedUser]?
}

// MARK: - LikedUser
struct LikedUser: Codable, ImageNameTableProtocol {
    
    let id: Int?
    let name, username, profilePhotoPath: String
    
    var profileImage: String? { profilePhotoPath }

    enum CodingKeys: String, CodingKey {
        case id, name, username
        case profilePhotoPath = "profile_photo_path"
    }
}



