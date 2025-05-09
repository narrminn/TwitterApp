import Foundation

class TweetManager: TweetManagerUseCase {
    var manager = NetworkManager()
    
    func tweetStore(description: String, tweetFiles: [[String: String?]], completion: @escaping((SuccessModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetStore.path
        
        let params = [
            "description": description,
            "tweet_files": tweetFiles
        ] as [String : Any]
        
        let headers = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: SuccessModel.self, method: .post, params: params, encodingType: .json, header: headers, completion: completion)
    }
    
    func tweetAll(page: Int, completion: @escaping ((TweetAllModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetAll.path
        
        let params: [String: Any] = [
            "page": page
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: TweetAllModel.self, method: .get, params: params, header: headers, completion: completion)
    }
    
    func tweetLike(tweetId: Int, completion: @escaping ((SuccessModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetLike(tweetId: tweetId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: SuccessModel.self, method: .post, params: nil, header: headers, completion: completion)
    }
    
    func tweetBookmark(tweetId: Int, completion: @escaping ((SuccessModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetBookmark(tweetId: tweetId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: SuccessModel.self, method: .post, params: nil, header: headers, completion: completion)
    }
    
    func tweetLikedUser(tweetId: Int, completion: @escaping ((LikedUserModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetLikedUser(tweetId: tweetId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: LikedUserModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func tweetDetail(tweetId: Int, completion: @escaping ((TweetDetailModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetDetail(tweetId: tweetId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: TweetDetailModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func tweetComment(tweetId: Int, completion: @escaping ((CommentModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetComment(tweetId: tweetId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: CommentModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func tweetCommentStore(comment: String, tweetId: Int, completion: @escaping ((CommentModel?, String?) -> Void)) {
        let path = TweetEndpoint.tweetCommentStore(tweetId: tweetId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        let params: [String: Any] = [
            "comment": comment
        ]
        
        manager.request(path: path, model: CommentModel.self, method: .post, params: params, header: headers, completion: completion)
    }
    
    //async await tweetAllOwn, tweetAllReplies, tweetAllLiked, tweetSaved.
    func tweetAllOwn(page: Int, userId: Int) async throws -> TweetAllModel? {
        let path = TweetEndpoint.tweetAllOwn(userId: userId).path
        
        let params: [String: Any] = [
            "page": page
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: TweetAllModel.self, method: .get, params: params, header: headers)
    }
    
    func tweetAllReplies(page: Int, userId: Int) async throws -> TweetAllModel? {
        let path = TweetEndpoint.tweetAllReplies(userId: userId).path
        
        let params: [String: Any] = [
            "page": page
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: TweetAllModel.self, method: .get, params: params, header: headers)
    }
    
    func tweetAllLiked(page: Int, userId: Int) async throws -> TweetAllModel? {
        let path = TweetEndpoint.tweetAllLiked(userId: userId).path
        
        let params: [String: Any] = [
            "page": page
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: TweetAllModel.self, method: .get, params: params, header: headers)
    }
    
    func tweetAllSaved(page: Int, userId: Int) async throws -> TweetAllModel? {
        let path = TweetEndpoint.tweetAllSaved(userId: userId).path
        
        let params: [String: Any] = [
            "page": page
        ]
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: TweetAllModel.self, method: .get, params: params, header: headers)
    }
}

