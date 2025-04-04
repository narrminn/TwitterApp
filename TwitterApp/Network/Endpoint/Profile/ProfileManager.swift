import Foundation

protocol ProfileManagerUseCase {
    func myProfile(completion: @escaping((ProfileModel?, String?) -> Void))
    func followingUser(userId: Int, completion: @escaping((FollowUserModel?, String?) -> Void))
    func followersUser(userId: Int, completion: @escaping((FollowUserModel?, String?) -> Void))
    func otherProfile(userId: Int, completion: @escaping((ProfileModel?, String?) -> Void))
    func followProfile(userId: Int, completion: @escaping((SuccessModel?, String?) -> Void))
}

class ProfileManager: ProfileManagerUseCase {
  
    var manager = NetworkManager()
    
    func myProfile(completion: @escaping ((ProfileModel?, String?) -> Void)) {
        let path = ProfileEndpoint.myProfile.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: ProfileModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func followingUser(userId: Int, completion: @escaping ((FollowUserModel?, String?) -> Void)) {
        let path = ProfileEndpoint.followingUser(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: FollowUserModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func followersUser(userId: Int, completion: @escaping ((FollowUserModel?, String?) -> Void)) {
        let path = ProfileEndpoint.followersUser(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: FollowUserModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func otherProfile(userId: Int, completion: @escaping ((ProfileModel?, String?) -> Void)) {
        let path = ProfileEndpoint.otherProfile(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: ProfileModel.self, method: .get, params: nil, header: headers, completion: completion)
    }
    
    func followProfile(userId: Int, completion: @escaping ((SuccessModel?, String?) -> Void)) {
        let path = ProfileEndpoint.followProfile(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: SuccessModel.self, method: .post, header: headers, completion: completion)
      }
}

