//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum ProfileEndpoint {
    case myProfile

    var path: String {
        switch self {
            case .myProfile:
                return NetworkHelper.shared.configureURL(endpoint: "profile/own")
        }
    }
}
