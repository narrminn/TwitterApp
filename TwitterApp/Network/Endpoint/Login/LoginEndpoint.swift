//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum LoginEndpoint {
    case login
    
    var path: String {
        switch self {
            case .login:
                return NetworkHelper.shared.configureURL(endpoint: "login")
        }
    }
}
