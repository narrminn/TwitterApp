//
//  TweetMockManager.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 04.05.25.
//

import Foundation

class TweetMockManager: TweetManagerUseCase {
    
    var manager = MockManager()
    
    func tweetStore(description: String, tweetFiles: [[String : String?]], completion: @escaping (SuccessModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    func tweetAll(page: Int, completion: @escaping (TweetAllModel?, String?) -> Void) {
        manager.loadFile(filename: "tweetAll", type: TweetAllModel.self, completion: completion)
    }
    
    func tweetLike(tweetId: Int, completion: @escaping (SuccessModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    func tweetBookmark(tweetId: Int, completion: @escaping (SuccessModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    func tweetLikedUser(tweetId: Int, completion: @escaping (LikedUserModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    func tweetDetail(tweetId: Int, completion: @escaping (TweetDetailModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    func tweetComment(tweetId: Int, completion: @escaping (CommentModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    func tweetCommentStore(comment: String, tweetId: Int, completion: @escaping (CommentModel?, String?) -> Void) {
        completion(nil, nil)
    }
    
    //Async await
    func tweetAllOwn(page: Int, userId: Int) async throws -> TweetAllModel? {
        return nil
    }
    
    func tweetAllReplies(page: Int, userId: Int) async throws -> TweetAllModel? {
        return nil
    }
    
    func tweetAllLiked(page: Int, userId: Int) async throws -> TweetAllModel? {
        return nil
    }
    
    func tweetAllSaved(page: Int, userId: Int) async throws -> TweetAllModel? {
        return nil
    }
}
