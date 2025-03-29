//
//  ProfileFilterOption.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

enum FollowFilterOption: Int, CaseIterable{
    case following
    case followers
    
    var description: String {
        switch self {
        case .following:
            return "Followings"
        case .followers:
            return "Followers"
        }
    }
}
