//
//  TweetManagerUseCase.swift
//  TwitterApp
//
//  Created by Narmin Alasova on 04.05.25.
//

import Foundation

protocol TweetManagerUseCase {
    func tweetStore(description: String, tweetFiles: [[String: String?]], completion: @escaping((SuccessModel?, String?) -> Void))
    func tweetAll(page: Int, completion: @escaping((TweetAllModel?, String?) -> Void))
    func tweetLike(tweetId: Int, completion: @escaping((SuccessModel?, String?) -> Void))
    func tweetBookmark(tweetId: Int, completion: @escaping((SuccessModel?, String?) -> Void))
    func tweetLikedUser(tweetId: Int, completion: @escaping((LikedUserModel?, String?) -> Void))
    func tweetDetail(tweetId: Int, completion: @escaping((TweetDetailModel?, String?) -> Void))
    func tweetComment(tweetId: Int, completion: @escaping((CommentModel?, String?) -> Void))
    func tweetCommentStore(comment: String, tweetId: Int, completion: @escaping((CommentModel?, String?) -> Void))
    
    //async await tweetAllOwn, tweetAllReplies, tweetAllLiked, tweetSaved.
    func tweetAllOwn(page: Int, userId: Int) async throws -> TweetAllModel?
    func tweetAllReplies(page: Int, userId: Int) async throws -> TweetAllModel?
    func tweetAllLiked(page: Int, userId: Int) async throws -> TweetAllModel?
    func tweetAllSaved(page: Int, userId: Int) async throws -> TweetAllModel?
}
