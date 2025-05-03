//
//  SettingOption.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 03.05.25.
//

import Foundation
import UIKit

enum SettingsOption: CaseIterable {
    case privacyPolicy
    case logOut

    var title: String {
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .logOut:
            return "Log out"
        }
    }

    var titleColor: UIColor {
        switch self {
        case .privacyPolicy:
            return .twitterBlue
        case .logOut:
            return .red
        }
    }
    
    var iconName: String {
        switch self {
        case .privacyPolicy:
            return "lock.shield" // SF Symbol
        case .logOut:
            return "arrowshape.turn.up.left" // SF Symbol
        }
    }

    var iconTintColor: UIColor {
        switch self {
        case .privacyPolicy:
            return .twitterBlue
        case .logOut:
            return .red
        }
    }
}

