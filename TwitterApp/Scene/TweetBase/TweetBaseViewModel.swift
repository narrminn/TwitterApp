//
//  TweetBaseViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import Foundation

class TweetBaseViewModel {
    
    var manager = TweetManager()
    
    var errorHandling: ((String) -> Void)?
    
    func likeTweet(tweetId: Int) {
        manager.tweetLike(tweetId: tweetId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            }
        }
    }
    
    func bookmarkTweet(tweetId: Int) {
        manager.tweetBookmark(tweetId: tweetId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            }
        }
    }
}
