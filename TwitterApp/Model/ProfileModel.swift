//
//  MyProfileModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 28.03.25.
//

import Foundation

// MARK: - MyProfileModel
struct ProfileModel: Codable {
    let message: String?
    let data: ProfileModelData?
}

// MARK: - MyProfileModelData
struct ProfileModelData: Codable {
    let user: ProfileModelUser?
}

// MARK: - MyProfileModelUser
struct ProfileModelUser: Codable, ProfileHeaderProtocol {
    let id: Int?
    let name, username, email: String
    let link, bio: String?
    let profilePhotoPath, profilePhotoUUID, profileBannerPath, profileBannerUUID: String?
    let followersCount, followingCount: Int?
    let isFollowing: Bool?
    
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
        case isFollowing = "is_following"
    }
}

