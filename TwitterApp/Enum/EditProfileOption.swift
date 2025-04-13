//
//  EditProfileOption.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 12.04.25.
//

import Foundation

enum EditProfileOption: Int, CaseIterable{
    case fullName
    case username
    case bio
    case website
    
    var description: String {
        switch self {
        case .fullName:
            return "Full name"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        case .website:
            return "Website"
        }
    }
}
