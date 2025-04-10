//
//  NotificationsModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 07.04.25.
//

import Foundation

struct NotificationsModel: Codable {
    let message: String?
    let data: NotificationsModelData?
    let meta: Meta?
}

struct NotificationsModelData: Codable {
    let notifications: [NotificationItem]?
}

struct NotificationItem: Codable {
    let id: Int?
    let description: String?
    let tweetID: Int?
    let name, username, profilePhotoPath, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, description
        case tweetID = "tweet_id"
        case name, username
        case profilePhotoPath = "profile_photo_path"
        case createdAt = "created_at"
    }
}

