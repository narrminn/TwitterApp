//
//  LoginModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let message: String?
    let data: LoginData?
}

// MARK: - LoginData
struct LoginData: Codable {
    let token: String?
    let user: User?
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, username, email, emailVerifiedAt: String?
    let emailCode, emailCodeExpired, profilePhotoPath, profilePhotoUUID: String?
    let profileBannerPath, profileBannerUUID, bio, link: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, username, email
        case emailVerifiedAt = "email_verified_at"
        case emailCode = "email_code"
        case emailCodeExpired = "email_code_expired"
        case profilePhotoPath = "profile_photo_path"
        case profilePhotoUUID = "profile_photo_uuid"
        case profileBannerPath = "profile_banner_path"
        case profileBannerUUID = "profile_banner_uuid"
        case bio, link
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
