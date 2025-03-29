//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum ProfileEndpoint {
    case myProfile
    case followingUser(userId: Int)
    case followersUser(userId: Int)

    var path: String {
        switch self {
            case .myProfile:
                return NetworkHelper.shared.configureURL(endpoint: "profile/own")
            case .followingUser(let userId):
                return NetworkHelper.shared.configureURL(endpoint: "follow/following/\(userId)")
            case .followersUser(let userId):
                return NetworkHelper.shared.configureURL(endpoint: "follow/followers/\(userId)")
        }
    }
}
