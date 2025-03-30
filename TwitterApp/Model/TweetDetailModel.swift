//
//  TweetDetailModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import Foundation

// MARK: - TweetDetailModel
struct TweetDetailModel: Codable {
    let message: String?
    let data: TweetDetailModelData?
}

// MARK: - TweetDetailModel
struct TweetDetailModelData: Codable {
    let tweet: TweetAll?
}

