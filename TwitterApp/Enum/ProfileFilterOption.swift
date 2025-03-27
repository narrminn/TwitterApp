//
//  ProfileFilterOption.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 27.03.25.
//

import Foundation

enum ProfileFilterOption: Int, CaseIterable{
    case tweets
    case replies
    case likes
    case savedTweets
    
    var description: String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Replies"
        case .likes:
            return "Likes"
        case .savedTweets:
            return "Saved"
        }
    }
}
