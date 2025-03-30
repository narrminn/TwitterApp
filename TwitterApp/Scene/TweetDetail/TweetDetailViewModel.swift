//
//  TweetDetailViewModel.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 30.03.25.
//

import Foundation

class TweetDetailViewModel {
    var tweetManager = TweetManager()
    
    var tweetId: Int
    var tweetDetail: TweetAll?
    var tweetComments: [Comment] = []
    
    var getTweetDetailSuccess: (() -> Void)?
    var getTweetCommentsSuccess: (() -> Void)?
    var tweetCommentStoreSuccess: (() -> Void)?
    
    var errorHandling: ((String) -> Void)?
    
    init (tweetId: Int) {
        self.tweetId = tweetId
    }
    
    func getTweetDetail() {
        tweetManager.tweetDetail(tweetId: tweetId){ response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetDetail = response.data?.tweet
                self.getTweetDetailSuccess?()
            }
        }
    }
    
    func getTweetComments() {
        tweetManager.tweetComment(tweetId: tweetId){ response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetComments = response.data?.comments ?? []
                self.getTweetCommentsSuccess?()
            }
        }
    }
    
    func tweetCommentStore(comment: String) {
        tweetManager.tweetCommentStore(comment: comment, tweetId: tweetId) { response, errorMessage in
            if let errorMessage {
                self.errorHandling?(errorMessage)
            } else if let response {
                self.tweetCommentStoreSuccess?()
            }
        }
    }
}
