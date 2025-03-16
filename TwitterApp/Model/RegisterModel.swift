//
//  RegisterModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 16.03.25.
//

import Foundation
// MARK: - RegisterModel
struct RegisterModel: Codable {
    let message: String?
    let data: RegisterData?
}

// MARK: - RegisterData
struct RegisterData: Codable {
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}

