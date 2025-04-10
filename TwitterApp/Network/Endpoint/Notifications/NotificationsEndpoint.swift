//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum NotificationsEndpoint {
    case notifications

    var path: String {
        switch self {
            case .notifications:
                return NetworkHelper.shared.configureURL(endpoint: "notification/all")
        }
    }
}
