//
//  CreateTweetViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 24.03.25.
//
import Foundation
import UIKit

class CreateTweetViewModel {
    var fileManager = FileNetworkManager()
    var tweetManager = TweetManager()

    var fileUploadSuccess: ((FileUploadModel) -> Void)?
    var tweetStoreSuccess: (() -> Void)?
    var errorHandling: ((String) -> Void)?
    
    var tweetFiles: [[String: String?]] = []
    
    func uploadImage(image: UIImage) {
        fileManager.fileUpload(file: image) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.fileUploadSuccess?(response)
            }
        }
    }
    
    
    func tweetStore(description: String) {
        tweetManager.tweetStore(description: description, tweetFiles: tweetFiles) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetStoreSuccess?()
            }
        }
    }
}
