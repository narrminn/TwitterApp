//
//  EditProfileModel .swift
//  TwitterApp
//
//  Created by Narmin Alasova on 25.04.25.
//

import Foundation

struct EditProfileModel {
    let type: EditProfileOption
    var value: String

    var keychainKey: String {
        switch type {
        case .fullName:
            return "name"
        case .username:
            return "username"
        case .bio:
            return "bio"
        case .website:
            return "link"
        }
    }
}
