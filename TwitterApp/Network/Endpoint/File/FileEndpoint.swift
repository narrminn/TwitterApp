//
//  LoginEndpoint.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation

enum FileEndpoint {
    case fileUpload
    
    var path: String {
        switch self {
            case .fileUpload:
                return NetworkHelper.shared.configureURL(endpoint: "file/upload")
        }
    }
}
