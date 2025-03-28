//
//  MyProfileModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 28.03.25.
//

import Foundation

// MARK: - MyProfileModel
struct MyProfileModel: Codable {
    let message: String?
    let data: MyProfileModelData?
}

// MARK: - MyProfileModelData
struct MyProfileModelData: Codable {
    let user: MyProfileModelUser?
}

// MARK: - MyProfileModelUser
struct MyProfileModelUser: Codable, ProfileHeaderProtocol {
    let id: Int?
    let name, username, email, bio: String
    let link: String
    let profilePhotoPath, profilePhotoUUID, profileBannerPath, profileBannerUUID: String?
    let followersCount, followingCount: Int?
    
    var headerImage: String? { profileBannerPath }
    
    var profileImage: String? { profilePhotoPath }
    
    var fullName: String { name }
    
    var following: Int {
        followingCount ?? 0
    }
    
    var follower: Int {
        followersCount ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case id, name, username, email, bio, link
        case profilePhotoPath = "profile_photo_path"
        case profilePhotoUUID = "profile_photo_uuid"
        case profileBannerPath = "profile_banner_path"
        case profileBannerUUID = "profile_banner_uuid"
        case followersCount = "followers_count"
        case followingCount = "following_count"
    }
}

