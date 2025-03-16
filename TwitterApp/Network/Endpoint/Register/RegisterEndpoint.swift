//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum RegisterEndpoint {
    case register
    case registerApprove(userId: Int)
    
    var path: String {
        switch self {
            case .register:
                return NetworkHelper.shared.configureURL(endpoint: "register")
            case .registerApprove(let userId):
                return NetworkHelper.shared.configureURL(endpoint: "register/approve/\(userId)")
        }
    }
}
