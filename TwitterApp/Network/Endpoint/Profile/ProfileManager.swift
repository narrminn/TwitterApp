import Foundation

protocol ProfileManagerUseCase {
    func myProfile(completion: @escaping((MyProfileModel?, String?) -> Void))
    func followingUser(userId: Int, completion: @escaping((FollowUserModel?, String?) -> Void))
    func followersUser(userId: Int, completion: @escaping((FollowUserModel?, String?) -> Void))
}

class ProfileManager: ProfileManagerUseCase {
  
    var manager = NetworkManager()
    
    func myProfile(completion: @escaping ((MyProfileModel?, String?) -> Void)) {
        let path = ProfileEndpoint.myProfile.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        manager.request(path: path, model: MyProfileModel.self, method: .get, params: nil, header: headers, completion: completion)
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
    
  
}

