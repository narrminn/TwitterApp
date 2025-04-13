import Foundation

protocol ProfileManagerUseCase {
    //async await
    func myProfile() async throws -> ProfileModel
    func otherProfile(userId: Int) async throws -> ProfileModel
    func followingUser(userId: Int) async throws -> FollowUserModel
    func followersUser(userId: Int) async throws -> FollowUserModel
    func followProfile(userId: Int) async throws -> SuccessModel
    
    //async await
    func searchProfile(page: Int, keyword: String) async throws -> SearchProfileModel
    func updateProfile(name: String, username: String, bio: String, link: String, profilePhoto: [String: String]?, profileBanner: [String: String]?) async throws -> SuccessModel
}

class ProfileManager: ProfileManagerUseCase {
    
    var manager = NetworkManager()
    
    //async await
    func myProfile() async throws -> ProfileModel {
        let path = ProfileEndpoint.myProfile.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: ProfileModel.self, method: .get, params: nil, header: headers)
    }
    
    func otherProfile(userId: Int) async throws -> ProfileModel {
        let path = ProfileEndpoint.otherProfile(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: ProfileModel.self, method: .get, params: nil, header: headers)
    }
    
    func followingUser(userId: Int) async throws -> FollowUserModel {
        let path = ProfileEndpoint.followingUser(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: FollowUserModel.self, method: .get, params: nil, header: headers)
    }
    
    func followersUser(userId: Int) async throws -> FollowUserModel {
        let path = ProfileEndpoint.followersUser(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: FollowUserModel.self, method: .get, params: nil, header: headers)
    }
    
    func followProfile(userId: Int) async throws -> SuccessModel {
        let path = ProfileEndpoint.followProfile(userId: userId).path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        return try await manager.request(path: path, model: SuccessModel.self, method: .post, params: nil, header: headers)
    }
    
    //async await
    func searchProfile(page: Int, keyword: String) async throws -> SearchProfileModel {
        let path = ProfileEndpoint.searchProfile.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        let params: [String: Any] = ["page": page, "keyword": keyword]
        
        return try await manager.request(path: path, model: SearchProfileModel.self, method: .get, params: params, header: headers)
    }
    
    func updateProfile(name: String, username: String, bio: String, link: String, profilePhoto: [String: String]?, profileBanner: [String: String]?) async throws -> SuccessModel {
        let path = ProfileEndpoint.updateProfile.path
        
        let headers: [String: String] = [
            "Authorization": "Bearer \(KeychainManager.shared.retrieve(key: "token") ?? "")"
        ]
        
        let params = [
            "name": name,
            "username": username,
            "bio": bio,
            "link": link,
            "profile_photo": profilePhoto,
            "profile_banner": profileBanner
        ] as [String : Any]
        
        return try await manager.request(path: path, model: SuccessModel.self, method: .post, params: params, encodingType: .json, header: headers)
    }
}

