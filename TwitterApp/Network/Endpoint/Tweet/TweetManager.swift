import Foundation

protocol TweetManagerUseCase {
    func tweetStore(description: String, tweetFiles: [[String: String?]], completion: @escaping((SuccessModel?, String?) -> Void))
}

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
}

