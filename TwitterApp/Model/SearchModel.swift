//
//  SearchModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 06.04.25.
//

import Foundation

// MARK: - SearchProfileModel
struct SearchProfileModel: Codable {
    let message: String?
    let data: SearchProfileModelData?
    let meta: Meta?
}

// MARK: - SearchProfileModelData
struct SearchProfileModelData: Codable {
    let users: [SearchProfile]?
}

// MARK: - SearchProfile
struct SearchProfile: Codable, ImageNameTableProtocol {
    let id: Int?
    let name, username: String
    let bio: String?
    let link: String?
    let profilePhotoPath: String?
    
    var profileImage: String? { profilePhotoPath }
    

    enum CodingKeys: String, CodingKey {
        case id, name, username, bio, link
        case profilePhotoPath = "profile_photo_path"
    }
}
