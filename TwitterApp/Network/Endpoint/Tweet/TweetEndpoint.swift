//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum TweetEndpoint {
    case tweetStore
    
    var path: String {
        switch self {
            case .tweetStore:
                return NetworkHelper.shared.configureURL(endpoint: "tweet/store")
        }
    }
}
